_    = require 'underscore'
path = require 'path'

# Root of the application 
root = path.normalize __dirname + '/../..'

# Default config variables shared by all environments
defaults =

	# path to the root of the application
	root_path: root

	# path to the server-side library of the application
	lib_path: root + '/lib'

	# path to publicly available files
	public_path: root + '/public'

	# path to view template files
	view_path: root + '/views'

envs = {}

module.exports = (env) ->
	config = _.defaults envs[env] || {}, defaults
	config.env = env
	config
