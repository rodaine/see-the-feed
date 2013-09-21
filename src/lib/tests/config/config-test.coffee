require('should')
config = require('../../config/config')

describe 'Config', ->
	describe 'Config', ->
		c = undefined

		beforeEach ->
			c = config()

		it 'should have all shared config properties defined', ->
			c.should.have.property('root_path')
			c.should.have.property('lib_path')
			c.should.have.property('public_path')
			c.should.have.property('view_path')
			c.should.have.property('view_engine')
			c.should.have.property('host')
			c.should.have.property('port')
			c.should.have.property('show_debug')
			c.should.have.property('favicon')
			c.should.have.property('session_secret')

		it 'should have different properties based on the environment specified', ->
			dev = config('development')
			c.show_debug.should.be.false
			dev.show_debug.should.be.true
