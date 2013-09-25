Messageable = require './messageable'

module.exports = class Feed extends Messageable

	addRedirect: (redirect) ->
		@redirects = @redirects || []
		@redirects.push redirect

	setMethod: (@method) ->
		
	setRaw: (@raw) ->
		# TODO: Prettify the XML

	setCode: (@code) ->
	
	setMeta: (@meta) ->
	
	addItem: (item) ->
		@items = @items || []
		@items.push item