###*
 * Checks if a string contains a valid URL
 * @param  {string}  url The URL to test for validity
 * @return {boolean}     Whether or not the string is valid URL
###
module.exports = (url) ->
	(/^(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/i).test url
