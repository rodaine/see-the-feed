Messageable = require './messageable'
FeedMeta    = require './feedMeta'
FeedItem    = require './feedItem'
pd          = require('pretty-data').pd

###*
 * Describes a processed RSS Feed, including feed meta data and individualt
 * items/articles
 * @type {class}
###
module.exports = class Feed extends Messageable

	# Has this feed been validated already?
	# If it hasn't been validated, it likely cannot be displayed at all.
	validated: false

	# Cannot set these since they'd end up on the prototype
	# This will be defaulted if not set by #inflate
	# redirects: []
	# items: []

	# Nulled for availability if never explicitly set
	method: null
	raw: null
	code: null
	meta: null


	###*
	 * Logs redirects and their status codes
	 * @param {string} url  The URL that the feed was redirected to
	 * @param {int}    code HTTP Code for the redirect, defaults to 301/Permanent
	###
	addRedirect: (url, code = 301) ->
		@redirects = @redirects || []
		@redirects.push
			url: url
			code: code


	###*
	 * Sets the method of feed retrieval (expecting either 'xml' or 'url')
	 * @param {string} method The method
	###
	setMethod: (@method) ->
	

	###*
	 * The raw XML from the feed (either retrieved from the URL or uploaded XML)
	 * which is 'prettified' for later output
	 * 
	 * @param {string} raw  The raw XML string
	###
	setRaw: (raw) ->
		@raw = pd.xml raw


	###*
	 * Sets the HTTP status code for the feed request, we're expecting a 200/OK
	 * @param {int} code The HTTP Status Code
	###
	setCode: (@code) ->
	

	###*
	 * Sets the Feed Meta object on the feed
	 * @param {FeedMeta} meta Feed Meta
	###
	setMeta: (meta) ->
		if meta instanceof FeedMeta
			@meta = meta
		else
			throw 'Meta must be an instance of FeedMeta'
	

	###*
	 * Captures a feed item/article object. Should be passed in order
	 * @param {FeedItem} item Feed Item
	###
	addItem: (item) ->
		if item instanceof FeedItem
			@items = @items || []
			@items.push item
		else
			throw 'Item must be an instance of FeedItem'


################################################################################
# VALIDATION
################################################################################


	###*
	 * Inflates collection properties with empty values
	###
	inflate: ->
		super()
		@items = @items || []
		@redirects = @redirects || []


	###*
	 * Validates the feed, its meta, and each of its feed items
	###
	validate: ->
		if @validated then return
		@validated = true

		# validate stream redirects
		@validateRedirects()

		# validate the status code
		@validateCode()

		# validate the feed items
		@validateItems()

		# validate the feed meta
		@validateMeta()


	###*
	 * Checks the redirects property for various issues
	###
	validateRedirects: ->
		# if there are any redirects, notify the user
		if @redirects?.length > 0
			msg = "The feed URL you provided was redirected #{@redirects.length} times"
			for redirect in @redirects
				msg += ", (#{redirect.code})⇒ #{redirect.url}"
			@addNotice msg

		# if there are too many redirects, warn the user
		if @redirects?.length >= 3
			@addWarning "The feed URL you provided was redirected #{@redirects.length} times, which significantly increases download times."


	###*
	 * Checks the HTTP Status Code 
	###
	validateCode: ->
		if [200, 304].indexOf(@code) < 0
			@addWarning "The feed returned a #{@code} status code. Most feed readers are expecting a 200/OK."


	###*
	 * Checks the items in the feed
	###
	validateItems: ->
		if not @items? or @items.length == 0
			@addWarning "There are no items/articles in your feed. That doesn't seem right..."

		if @items?.length > 10
			@addWarning "There are #{@items.length} items/articles in your feed, which is potentially a lot. Depending on your publication rate, you might want to minimize the number of items in your feed to reduce bandwidth."

		# validate each feed item
		if @items?
			for item in @items
				item?.validate?()

	###*
	 * Checks the meta information of the feed
	###
	validateMeta: ->

		if not @meta?
			@addError 'Unable to retrieve the meta information for the feed.'

		# validate the feed meta
		@meta?.validate?()
