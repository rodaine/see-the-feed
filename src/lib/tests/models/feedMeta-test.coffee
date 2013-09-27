FeedMeta =    require '../../models/feedMeta'
Messageable = require '../../models/messageable'
should =      require 'should'
sinon =       require 'sinon'

describe 'Model', ->
	describe 'FeedMeta', ->
		meta = undefined


		beforeEach ->
			meta = new FeedMeta


		it 'should inherit from Messageable', ->
			meta.should.be.an.instanceOf Messageable


		it 'should have all non-collection properties defined as null', ->
			meta.should.have.property 'type' # the constructor will not allow a null in this field, so no expected value
			meta.should.have.property 'title', null
			meta.should.have.property 'description', null
			meta.should.have.property 'date', null
			meta.should.have.property 'link', null
			meta.should.have.property 'feedUrl', null
			meta.should.have.property 'feedLink', null
			meta.should.have.property 'author', null
			meta.should.have.property 'language', null
			meta.should.have.property 'favicon', null
			meta.should.have.property 'copyright', null
			meta.should.have.property 'generator', null
			meta.should.have.property 'cloud', null
			meta.should.have.property 'image', null


		it 'should inflate all properties that are missing', ->
			meta.should.not.have.property 'messages'
			meta.should.not.have.property 'categories'
			meta.inflate()
			meta.should.have.property 'messages'
			meta.should.have.property 'categories'


		it 'should run through and validate all properties', ->
			
			
