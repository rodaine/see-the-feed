BaseController = require './base'

module.exports = class IndexController extends BaseController

	index: (req, res) ->
		res.render 'index'
