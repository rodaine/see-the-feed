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
			c.should.have.property('view_cache')
			c.should.have.property('csrf')

		it 'should show debug messages in dev environment', ->
			dev = config('development')
			c.show_debug.should.be.false
			dev.show_debug.should.be.true

		it 'should not use a view cache in dev environment', ->
			dev = config('development')
			c.view_cache.should.be.ok
			dev.view_cache.should.not.be.ok

		it 'should have 0.0.0.0 for host in staging environment', ->
			stg = config('staging')
			c.host.should.equal '127.0.0.1'
			stg.host.should.equal '0.0.0.0'

		it 'should hold a reference to the npm package object', ->
			c.should.have.property('pkg')
			c.pkg.should.have.property('name')
			c.pkg.should.have.property('version')
