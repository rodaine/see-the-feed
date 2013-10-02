config               = require('../config/config')(process.env.NODE_ENV || 'development')
containsHtmlEntities = require '../utils/containsHtmlEntities'
isValidUrl           = require '../utils/isValidUrl'
Messageable          = require './messageable'
setPropertyIfDefined = require '../utils/setPropertyIfDefined'

module.exports = class FeedItem extends Messageable

	title: null        # the title of the item
	description: null  # the description/content of the item
	summary: null      # the summary of the item
	date: null         # the publication date of the item
	link: null         # the link to the actual item
	guid: null         # the unique identifier for this item
	author: null       # the author of the item
	image: null        # the image for this item
	# categories: []   # the category/tag terms for the feed item
	# enclosures: []   # the included media on the feed item (ex, podcast)
		
	constructor: (raw = {}) ->
		set = setPropertyIfDefined raw, @

		set 'title', 'title'
		set 'description', 'description'
		set 'summary', 'summary'
		set 'pubDate', 'date'
		set 'link', 'link'
		set 'author', 'author'
		set 'guid', 'guid'
		set 'image', 'image'
		set 'categories', 'categories'
		set 'enclosures', 'enclosures'

		@_raw = raw if config.show_debug


	inflate: ->
		super()
		@categories = @categories || []
		@enclosures = @enclosures || []
		
	validate: ->
	
