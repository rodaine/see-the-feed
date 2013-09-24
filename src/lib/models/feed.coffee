
module.exports = class Feed

	# method:   undefined
	# raw:      undefined
	# meta:     undefined
	# articles: undefined

	constructor: () ->
		@messages = {}

	_addMessage: (level, message) ->
		@messages[level] = @messages[level] || []
		@messages[level]?.push message

	addError: (message) -> @_addMessage 'errors', message

	addWarning: (message) -> @_addMessage 'warnings', message

	addNotice: (message) -> @_addMessage 'notice', message

	addRedirect: (redirect) ->
		@redirects = @redirects || []
		@redirects.push redirect

	setRaw: (@raw) ->
		# TODO: Prettify the XML
