module.exports = (app, config) ->

	app.resource('/', require('../controllers/index'))
