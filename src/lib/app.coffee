# capture configuration properties
config = require('./config/config')(process.env.NODE_ENV || 'development')

# create express app
app = require('express')()

# bootstrap express properties
require('./config/express')(app, config)


# listen on the configured port & host (usually local, but 0.0.0.0 for nitrous.io)
app.listen config.port, config.host, ->
	if config.show_debug
		console.log "#{config.pkg.name} (v#{config.pkg.version}) started in #{config.env} on #{config.host}:#{config.port}"
