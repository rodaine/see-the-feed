BaseController = require './base'
Feed           = require '../models/feed'
FeedParser     = require 'feedparser'
request        = require 'request'
resumer        = require 'resumer'

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

		if req.body.url
			stream = @getUrlStream req.body.url, res
		else if req.body.xml
			stream = @getXmlStream req.body.xml, res

		if not stream
			return res.send 'Yeah, you didn\'t give me anything to work with here'

		stream
			.on('error',    @streamError)
			.on('redirect', @streamRedirect)
			.pipe(new FeedParser)
				.on('error',    @feedError)
				.on('meta',     @feedMeta)
				.on('readable', @feedReadable)
				.on('end',      @feedEnd(res))


	###*
	 * Creates an HTTP request Readable stream from URL
	 * @param  {string} url URL to run the HTTP request against
	 * @return {object}     Readable stream
	###
	getUrlStream: (url, res) -> 
		try
			return request url
		catch e
			console.error e if res.locals.config.show_debug
			res.send("Yeah, I can't work with that: #{e}")


	###*
	 * Creates a Readable stream from a raw XML string
	 * @param  {string} xml The raw XML to wrap in a stream
	 * @return {object}     Readable stream
	###
	getXmlStream: (xml, res) -> 
		try
			return resumer().queue(xml).end()
		catch e
			console.error e if res.locals.config.show_debug
			res.send("Yeah, I can't work with that: #{e}")


	###*
	 * Handle any errors from the in-bound Stream
	 * @param  {object} error The error object from the stream
	###
	streamError: (error) ->
		console.log "Stream Error: #{error}"


	###*
	 * Handle & count any redirects from the in-bound Stream
	###
	streamRedirect: () ->
		console.log "Redirect Occurred"


	###*
	 * Handle any errors when the parser attempts to read the feed XML
	 * @param  {object} error The error object from FeedParser
	###
	feedError: (error) ->
		console.log error


	###*
	 * Handle the meta from the feed
	 * @param  {object} meta Parsed feed metadata
	###
	feedMeta: (meta) ->
		console.log meta


	###*
	 * Handles readable data returned from FeedParser (the articles)
	###
	feedReadable: ->
		stream = @
		while item = stream.read()
			console.log "#{item.title}"


	###*
	 * Handles reaching the end of the feed articles and closes out the response
	 * @param  {object} res The HTTP Response object
	###
	feedEnd: (res) -> ->
		res.send 'Done reading feed.'
