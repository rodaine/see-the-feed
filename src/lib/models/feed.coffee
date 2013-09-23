
module.exports = class Feed

	# raw:      undefined
	# errors:   undefined
	# warnings: undefined
	# notices:  undefined
	# meta:     undefined
	# articles: undefined

	constructor: (@method) ->
		@errors   = []
		@warnings = []
		@notices  = []

	_addMessage: (level, message) ->
		@[level]?.push message

	addError: (message) -> @_addMessage 'errors', message

	addWarning: (message) -> @_addMessage 'warnings', message

	addNotice: (message) -> @_addMessage 'notice', message
