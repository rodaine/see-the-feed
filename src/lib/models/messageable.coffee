###*
 * Describes all the message levels that can be sent to a Messageable
 *   key   - pretty name for creating the addLevel methods on Messageable
 *   value - property name of the message collection on a Messageable
 * @type {[type]}
###
messageLevels =
	'Error': 'errors'
	'Warning': 'warnings'
	'Notice': 'notices'


###*
 * Add a message to a Messageable at the specified level
 * @param {Messageable} messageable A Messageable instance
 * @param {string}      lvl         The level of the message (ex: errors)
 * @param {string}      message     The actual message
 * @returns {function}  Return curried add{Level} function including the defined level
###
addMessage = (lvl) -> (message) ->
	@messages = @messages || {}
	@messages[lvl] = @messages[lvl] || []
	@messages[lvl].push message


###*
 * A class that can recieve Error/Warning/Notice messages and store them
 * @type {class}
###
module.exports = Messageable = class Messageable

	###*
	 * Fills in the messages property to include empty but defined values
	 * Saves a lot of trouble with null checking if it can be avoided
	###
	inflate: -> 
		@messages = @messages || {}
		for name, level of messageLevels
			@messages[level] = @messages[level] || []


###*
 * Adds add{Level} methods to Messageable prototype for each message level
###
for name, level of messageLevels
	Messageable.prototype["add#{name}"] = addMessage level
