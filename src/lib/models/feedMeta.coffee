config               = require('../config/config')(process.env.NODE_ENV || 'development')
containsHtmlEntities = require '../utils/containsHtmlEntities'
isValidUrl           = require '../utils/isValidUrl'
Messageable          = require './messageable'
setPropertyIfDefined = require '../utils/setPropertyIfDefined'


###*
 * Describes the meta information about the feed and its contents
 * @type {class}
###
module.exports = class FeedMeta extends Messageable
	
	type: null         # the type of rss feed (ex, Atom / RSS 2.0 / etc.)
	title: null        # the title of the feed
	description: null  # the description of the feed
	date: null         # the last publication date of the feed
	link: null         # the link to the actual publication (blog/podcast/etc)
	feedUrl: null      # the request URL for this feed (passed in by stream, null if XML)
	feedLink: null     # the canonical feed URL specified by the feed meta
	author: null       # the author of the feed (author of item bubbles up to this if unspecified)
	language: null     # the language of the feed content
	favicon: null      # the favicon specified for the feed
	copyright: null    # the copyright specification for the feed contents
	generator: null    # the software that generated the feed
	cloud: null        # the pubsub details for the feed
	image: null        # the logo or other identifying image for the feed
	# categories: []   # the category terms for the feed as a whole
	

	###*
	 * Parses the contents of the raw meta object
	 * @param  {object} raw The raw feed meta object
	###
	constructor: (raw = {}) ->

		@type = raw['#type'] + ' ' + raw['#version']

		set = setPropertyIfDefined raw, @
		set 'title', 'title'
		set 'description', 'description'
		set 'pubDate', 'date'
		set 'link', 'link'
		set 'xmlUrl', 'feedLink'
		set 'author', 'author'
		set 'language', 'language'
		set 'favicon', 'favicon'
		set 'copyright', 'copyright'
		set 'generator', 'generator'
		set 'cloud', 'cloud'
		set 'image', 'image'
		set 'categories', 'categories'

		@_raw = raw if config.show_debug


################################################################################
# VALIDATION
################################################################################


	###*
	 * Inflates collection properties with empty values
	###
	inflate: ->
		super()
		@categories = @categories || []


	###*
	 * Validates all the properties on the FeedMeta object
	###
	validate: ->
		@validateTitle()
		@validateDescription()
		@validateDate()
		@validateLink()
		@validateFeedLink()
		@validateFavicon()


	###*
	 * Ensures the title exists and that it doesn't contain HTML entities
	###
	validateTitle: ->
		if not @title?.trim()
			@addError 'Your feed is missing a title! This field is required.'
			return
		if containsHtmlEntities @title
			@addError 'Your feed title has HTML entities in it (ex: &amp;). Most feed readers will escape the contents of the title. Use the actual Unicode characters instead.'


	###*
	 * Ensures the description exists and that it doesn't contain HTML entities
	###
	validateDescription: ->
		if not @description?.trim()
			@addError 'Your feed is missing a description! This field is required.'
			return
		if containsHtmlEntities @description
			@addError 'Your feed description has HTML entities in it (ex: &amp;). Most feed readers will escape the contents of the description. Use the actual Unicode characters instead.'


	###*
	 * Ensures the date is valid and that it is at some point in the past
	###
	validateDate: ->
		if not @date? then return
		if not (@date instanceof Date)
			@addWarning 'Your feed has specified an invalid publication date.'
			return
		if new Date() < @date
			@addNotice 'Why is your publication date in the future?'


	###*
	 * Ensures the feed source link exists and is valid
	###
	validateLink: ->
		if not @link?
			@addError 'Your feed is missing a link to the corresponding website! This field is required.'
			return
		if not isValidUrl @link
			@addWarning 'Your link is not a valid URL.'


	###*
	 * Ensures the feed url is valid and matches the actual address requested
	###
	validateFeedLink: ->
		if not @feedLink? then return
		if not isValidUrl @feedLink
			@addWarning "Your feed's self-referencing URL is invalid: #{@feedLink}"
			return
		if @feedUrl? and @feedLink != @feedUrl
			@addNotice "Your feed's self-referencing URL (#{@feedLink}) does not match the actual URL of the request (#{@feedUrl})."


	###*
	 * Ensures the favicon is a valid URL, if provided
	###
	validateFavicon: ->
		if not @favicon?.trim() then return
		if not isValidUrl @favicon
			@addNotice "Your favicon URL is invalid: #{@favicon}"

