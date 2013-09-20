_    = require 'underscore'
path = require 'path'

###*
 * Root path to the application
 * @type {string}
###
root = path.normalize __dirname + '/../..'

###*
 * Default config variables shared by all environments
 * @type {object}
###
defaults =

	# path to the root of the application
	root_path: root

	# path to the server-side library of the application
	lib_path: root + '/lib'

	# path to publicly available files
	public_path: root + '/public'

	# path to view template files
	view_path: root + '/views'

	# view engine to use for this project
	view_engine: 'jade'

	# host ip to use for the application
	host: '127.0.0.1'

	# port number for the application
	port: 8080

	# whether or not to print certain debug messages to the console.
	show_debug: false


###*
 * Environment specific values for the default variables
 * @type {object}
###
envs = 

	staging:
		host: '0.0.0.0'

	development:
		show_debug: true

###*
 * Builds and returns the config object from the default and provided environment name
 * @param  {string} env The environment of the application
 * @return {object}     The config object
###
module.exports = (env) ->
	config = _.defaults envs[env] || {}, defaults
	config.env = env
	config
