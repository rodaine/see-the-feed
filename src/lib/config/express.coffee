express = require('express')
pkg     = require('../../package.json')

###*
 * Configures the Express app based on the provided config
 * @param  {object} app    The ExpressJS application
 * @param  {object} config The configuration object for the app
###
module.exports = (app, config) ->
	
	# output pretty HTML (line breaks and tabs) 
	app.locals.pretty = config.show_debug

	# show full stack trace on error
	app.set 'showStackError', config.show_debug

	# specify the location of the view template files
	app.set 'views', config.view_path

	# specify the view engine to used
	app.set 'view engine', config.view_engine

	# compress all ascii/utf8 files using gzip/deflate
	app.use express.compress
		filter: (req, res) -> return /json|text|javascript|css/.test(res.getHeader('Content-Type'))
		level: 9

	# uses the favicon specified in the config. 
	# Defaults to the connect icon when undefined
	app.use express.favicon(config.public_path + config.favicon) if config.favicon

	# set up the folder where files can be served statically (public)
	app.use express.static config.public_path

	# log request information to the console
	app.use express.logger('dev') if config.show_debug

	# adds the config object to the response 
	# for easy access while processing.
	app.use (req, res, next) ->
		res.locals.config = config
		next()

	# parses and stores cookies on the req
	app.use express.cookieParser()

	# parses the request body into JS if applicable
	app.use express.bodyParser()

	# provides faux http method support for (PUT/DELETE/etc. requests)
	app.use express.methodOverride()

	# sets up the session 
	app.use express.session
		secret: config.session_secret

	# csrf protection unless developing (for tests)
	app.use(express.csrf()) unless 'development' == config.env

	app.use (req, res, next) ->
		res.removeHeader 'X-Powered-By'
		next()

	# uses routes (bootstrapped later)
	app.use app.router

	# catch 500ish errors
	app.use (err, req, res, next) ->
		console.error err if config.showDebug
		res.send(500, 'Something broke...')

	# and 404s if we get here...
	app.use (req, res, next) ->
		res.send(404, 'Resource not found...')
