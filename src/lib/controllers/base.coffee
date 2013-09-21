

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
