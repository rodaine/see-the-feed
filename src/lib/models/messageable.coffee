
addMessage = (messageable, level, message) ->
	messageable.messages = messageable.messages || {}
	messageable.messages[level] = messageable.messages[level] || []
	messageable.messages[level].push message

module.exports = class Messageable

	addError: (message) -> addMessage @, 'errors', message

	addWarning: (message) -> addMessage @, 'warnings', message

	addNotice: (message) -> addMessage @, 'notices', message
