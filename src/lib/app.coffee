# capture configuration properties
config = require('./config/config')(process.env.NODE_ENV || 'development')

# enable resourceful routing
require('express-resource')

# create express app
app = require('express')()

# bootstrap express properties
require('./config/express')(app, config)

# bootstrap routes
require('./config/routes')(app, config)

# listen on the configured port & host
app.listen config.port, config.host, ->
	if config.show_debug
		console.log "#{config.pkg.name} (v#{config.pkg.version}) started in #{config.env} on #{config.host}:#{config.port}"
