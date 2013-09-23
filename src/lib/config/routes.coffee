IndexController = require '../controllers/index'
FeedController = require '../controllers/feeds'

module.exports = (app, config) ->

	app.resource('/', new IndexController)
	app.resource('feeds/', new FeedController)
