BaseController = require './base'
Feed           = require '../models/feed'
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
			.on('error',    @streamError(feed, res))
			.on('redirect', @streamRedirect(feed, res))
			.pipe(new FeedParser)
				.on('error',    @feedError(feed, res))
				.on('meta',     @feedMeta(feed, res))
				.on('readable', @feedReadable(feed, res))
				.on('end',      @feedEnd(feed, res))


	###*
	 * Creates an HTTP request Readable stream from URL
	 * @param  {string} url URL to run the HTTP request against
	 * @return {object}     Readable stream
	###
	getUrlStream: (url, feed, res) ->
		feed.method = 'url'
		return request url, (error, response, body) ->
			if error
				msg = util.format 'Hey, having some issues grabbing your feed ⋯ %s', error.message
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
		feed.method = 'xml'
		feed.setRaw xml
		try
			return resumer().queue(xml).end()
		catch e
			msg = utils.format "Yo, having some trouble grabbing that XML you gave me ⋯ %s", e
			console.error msg if res.locals.config.show_debug
			feed.addError msg
			res.json feed


	###*
	 * Handle any errors from the in-bound Stream
	 * @param  {object} error The error object from the stream
	###
	streamError: (feed, res) -> (error) ->
		msg = utils.format "Uhm, ran into an issue reading all that XML ⋯ %s", e
		console.error msg if res.locals.config.show_debug
		feed.addError msg
		res.json feed


	###*
	 * Handle & collect any redirects from the in-bound Stream
	###
	streamRedirect: (feed, res) -> ->
		console.log "Redirect on feed stream" if res.locals.config.show_debug
		feed.addRedirect @redirects[@redirects.length - 1]


	###*
	 * Handle any errors when the parser attempts to read the feed XML
	 * @param  {object} error The error object from FeedParser
	###
	feedError: (feed, res) -> (error) ->
		console.log "Feed Error: #{error}"


	###*
	 * Handle the meta from the feed
	 * @param  {object} meta Parsed feed metadata
	###
	feedMeta: (feed, res) -> (meta) ->
		console.log "Meta Recieved"


	###*
	 * Handles readable data returned from FeedParser (the articles)
	###
	feedReadable: (feed, res) -> ->
		stream = @
		while item = stream.read()
			console.log "#{item.title}"


	###*
	 * Handles reaching the end of the feed articles and closes out the response
	 * @param  {object} res The HTTP Response object
	###
	feedEnd: (feed, res) -> ->
		console.log 'Done processing feed.' if res.locals.config.show_debug
		res.json feed
