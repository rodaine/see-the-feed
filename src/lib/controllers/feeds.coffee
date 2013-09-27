BaseController = require './base'
Feed           = require '../models/feed'
FeedMeta       = require '../models/feedMeta'
FeedItem       = require '../models/feedItem'
FeedParser     = require 'feedparser'
request        = require 'request'
resumer        = require 'resumer'
util           = require 'util'

###*
 * Controller for the Feeds Route, '/feeds'
 * @type {class}
###
module.exports = class FeedController extends BaseController


	###*
	 * Redirects any GET requests back to the home page
	 * @param  {object} req The request object
	 * @param  {object} res The response object
	###
	index: (req, res) -> res.redirect 301, '/'


	###*
	 * Handles POST requests to grab the feed
	 * @param  {object} req The request object
	 * @param  {object} res The response object
	###
	create: (req, res) =>
		stream = undefined
		feed = new Feed

		if req.body.url
			stream = @getUrlStream req.body.url, feed, res
		else if req.body.xml
			stream = @getXmlStream req.body.xml, feed, res

		if not stream
			msg = 'Yeah, you didn\'t give me any data to work with, buddy.'
			console.error msg if res.locals.config.show_debug
			feed.addError msg
			res.json feed
			return

		stream
			.on('error',    @handleStreamError(feed, res))
			.on('redirect', @handleStreamRedirect(feed, res))
			.pipe(new FeedParser({ addmeta: false }))
				.on('error',    @handleFeedError(feed, res))
				.on('meta',     @handleFeedMeta(feed, res))
				.on('readable', @handleFeedReadable(feed, res))
				.on('end',      @handleFeedEnd(feed, res))


	###*
	 * Creates an HTTP request Readable stream from URL
	 * @param  {string} url URL to run the HTTP request against
	 * @return {object}     Readable stream
	###
	getUrlStream: (url, feed, res) ->
		feed.setMethod 'url'
		return request url, (error, response, body) ->
			feed.setCode response.statusCode
			if error
				msg = util.format 'HTTP Stream Error: %s', error.message
				console.error msg if res.locals.config.show_debug
				feed.addError msg
				res.json feed
			else
					feed.setRaw body


	###*
	 * Creates a Readable stream from a raw XML string
	 * @param  {string} xml The raw XML to wrap in a stream
	 * @return {object}     Readable stream
	###
	getXmlStream: (xml, feed, res) ->
		feed.setMethod = 'xml'
		feed.setCode 200
		feed.setRaw xml
		try
			return resumer().queue(xml).end()
		catch e
			feed.setCode 0
			msg = utils.format "XML Stream Error: %s", e.message
			console.error msg if res.locals.config.show_debug
			feed.addError msg
			res.json feed


	###*
	 * Handle any errors from the in-bound Stream
	 * @param  {object} error The error object from the stream
	###
	handleStreamError: (feed, res) -> (error) ->
		msg = utils.format "Stream Error: %s", error.message
		console.error msg if res.locals.config.show_debug
		feed.addError msg
		res.json feed


	###*
	 * Handle & collect any redirects from the in-bound Stream
	###
	handleStreamRedirect: (feed, res) -> ->
		console.log "Stream Redirect" if res.locals.config.show_debug
		redirect = @redirects[@redirects.length - 1]
		feed.addRedirect redirect.redirectUri, redirect.statusCode


	###*
	 * Handle any errors when the parser attempts to read the feed XML
	 * @param  {object} error The error object from FeedParser
	###
	handleFeedError: (feed, res) -> (error) ->
		msg = util.format "Feed Error: %s", error.message
		console.log msg if res.locals.config.show_debug
		feed.addError msg


	###*
	 * Handle the meta from the feed
	 * @param  {object} meta Parsed feed metadata
	###
	handleFeedMeta: (feed, res) -> (meta) ->
		console.log "Feed Meta Received" if res.locals.config.show_debug
		feed.setMeta new FeedMeta meta


	###*
	 * Handles readable data returned from FeedParser (the articles)
	###
	handleFeedReadable: (feed, res) -> ->
		while item = @.read()
			console.log "Feed Item Received: #{item.title}" if res.locals.config.show_debug
			feed.addItem new FeedItem item


	###*
	 * Handles reaching the end of the feed articles and closes out the response
	 * @param  {object} res The HTTP Response object
	###
	handleFeedEnd: (feed, res) -> ->
		console.log 'Done processing feed.' if res.locals.config.show_debug
		res.json feed
