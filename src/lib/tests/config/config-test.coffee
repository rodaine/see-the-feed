require('should')
config = require('../../config/config')

describe 'Config', ->
	describe 'Config', ->
		c = undefined

		beforeEach ->
			c = config()

		it 'should have logical filepaths to important directories', ->
			c.should.have.property('root_path')
			c.should.have.property('lib_path')
			c.should.have.property('public_path')
			c.should.have.property('view_path')
