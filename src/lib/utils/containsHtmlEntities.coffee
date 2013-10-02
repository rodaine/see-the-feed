###*
 * Checks if a string contains HTML entities (ex: &amp;)
 * @param  {string} str The string to test
 * @return {boolean}    Whether or not the string contains an HTML entitiy
###
module.exports = (str) ->
	(/&(?:[a-z]+|#x?\d+);/gi).test str
