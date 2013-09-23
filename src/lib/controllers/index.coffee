BaseController = require './base'

###*
 * Controller for the Index Route, '/'
 * @type {class}
###
module.exports = class IndexController extends BaseController

	###*
	 * Handles GET requests to the root page
	 * @param  {object} req The request object
	 * @param  {object} res The response object
	###
	index: (req, res) ->
		res.render 'index'
