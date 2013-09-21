env    = process.env.NODE_ENV || 'development'
config = require('./config/config')(env)
pkg    = require('../package.json')

# create express app
app = require('express')()

# bootstrap express properties
require('./config/express')(app, config)

app.listen config.port, config.host

if config.show_debug
	console.log "#{pkg.name} (version #{pkg.version}) started in #{env} on #{config.host}:#{config.port}"
