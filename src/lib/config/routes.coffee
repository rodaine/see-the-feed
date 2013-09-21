module.exports = (app, config) ->

	app.resource('/', require('../controllers/index'))
	app.resource('feeds/', require('../controllers/feeds'))
