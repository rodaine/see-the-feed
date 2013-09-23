
###*
 * Just passes on the request to the next route/middleware/handler.
 * @param  {object}   req  The request object
 * @param  {object}   res  The response object
 * @param  {Function} next Pass req/res to the next route
###
noop = (req, res, next) -> next()


###*
 * Base, shared functionality for a resource controller
###
class ControllerBase

	###*
	 * Handler for GET /{resource}
	###
	index: noop

	###*
	 * Handler for POST /{resource}
	###
	create: noop

	###*
	 * Handler for GET /{resource}/:ids
	###
	show: noop

	###*
	 * Handler for PUT /{resource}/:id
	###
	update: noop

	###*
	 * Handler for DELETE /{resource}/:id
	###
	destroy: noop


module.exports = ControllerBase
