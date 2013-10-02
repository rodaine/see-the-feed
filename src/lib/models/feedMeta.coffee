config = require('../config/config')(process.env.NODE_ENV || 'development')
Messageable = require './messageable'
containsHtmlEntities = require '../utils/containsHtmlEntities'
isValidUrl           = require '../utils/isValidUrl'
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


	validate: ->
