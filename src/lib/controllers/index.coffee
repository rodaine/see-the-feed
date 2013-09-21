BaseController = require './base'

class IndexController extends BaseController

	index: (req, res) ->
		res.render 'index'

module.exports = new IndexController
