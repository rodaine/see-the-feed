require('should')
BaseController = require('../../controllers/base')

describe 'Controller', ->
	describe 'Base', ->
		base = undefined

		beforeEach ->
			base = new BaseController

		it 'should define properties for each of the CRUD methods', ->
			base.should.have.property 'index'
			base.should.have.property 'create'
			base.should.have.property 'show'
			base.should.have.property 'update'
			base.should.have.property 'destroy'
