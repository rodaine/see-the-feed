Feed =        require '../../models/feed'
FeedItem =    require '../../models/feedItem'
FeedMeta =    require '../../models/feedMeta'
Messageable = require '../../models/messageable'
should =      require 'should'
sinon =       require 'sinon'

describe 'Model', ->
	describe 'Feed', ->
		feed = undefined


		beforeEach ->
			feed = new Feed


		it 'should inherit from Messageable', ->
			feed.should.be.an.instanceOf Messageable


		it 'should capture redirects from the stream', ->
			url = 'http://www.example.com'
			code = 302

			feed.addRedirect url
			feed.addRedirect url, code

			feed.redirects.should.have.length 2

			feed.redirects[0].should.have.property 'url', url
			feed.redirects[0].should.have.property 'code', 301
			feed.redirects[1].should.have.property 'code', code


		it 'should track which method was used to obtain the feed: url/xml', ->
			method = 'url'
			feed.setMethod method
			feed.method.should.equal method


		it 'should capture the raw XML', ->
			raw = 'this is the raw "xml"'
			feed.setRaw raw
			feed.raw.should.equal raw


		it 'should prettify the raw XML', ->
			ugly = '<?xml><node><child/></node>'
			pretty = '''
				<?xml>
				<node>
				  <child/>
				</node>
			'''
			feed.setRaw ugly
			feed.raw.should.equal pretty


		it 'should set the HTTP Code returned from the stream', ->
			code = 200
			feed.setCode code
			feed.code.should.equal code


		it 'should set the feed meta object to an instance of FeedMeta', ->
			badMeta = {}
			goodMeta = new FeedMeta

			(-> feed.setMeta badMeta).should.throw()

			feed.setMeta goodMeta
			feed.meta.should.equal goodMeta


		it 'should capture items/articles from the feed', ->
			badArticle = {}
			goodArticle = new FeedItem

			(-> feed.addItem badArticle).should.throw()

			feed.addItem goodArticle
			feed.items.should.have.length 1
			feed.items.should.containEql goodArticle


		it 'should have all non-collection properties defined as null', ->
			feed.should.have.property 'method', null
			feed.should.have.property 'raw', null
			feed.should.have.property 'code', null
			feed.should.have.property 'meta', null


		it 'should inflate all properties that are missing', ->
			feed.should.not.have.property 'messages'
			feed.should.not.have.property 'items'
			feed.should.not.have.property 'redirects'

			feed.inflate()

			feed.should.have.property 'messages'
			feed.should.have.property 'items'
			feed.should.have.property 'redirects'


		it 'should validate itself and its children only once!', ->
			meta = new FeedMeta
			item1 = new FeedItem
			item2 = new FeedItem

			sinon.spy feed,  'validateRedirects'
			sinon.spy feed,  'validateCode'
			sinon.spy feed,  'validateItems'
			sinon.spy feed,  'validateMeta'
			sinon.spy meta,  'validate'
			sinon.spy item1, 'validate'
			sinon.spy item2, 'validate'

			feed.setMeta meta
			feed.addItem item1
			feed.addItem item2

			feed.validate()
			feed.validate()

			feed.validateRedirects.calledOnce.should.be.ok
			feed.validateCode.calledOnce.should.be.ok
			feed.validateItems.calledOnce.should.be.ok
			feed.validateMeta.calledOnce.should.be.ok

			meta.validate.calledOnce.should.be.ok
			item1.validate.calledOnce.should.be.ok
			item2.validate.calledOnce.should.be.ok


		it 'should give notice of the redirection path', ->
			feed.inflate()

			feed.validateRedirects()
			feed.messages.notices.should.have.length 0

			feed.addRedirect 'http://www.example.com' for i in [1..2]
			feed.validateRedirects()
			feed.messages.notices.should.have.length 1


		it 'should give a warning if there are 3 or greater redirects', ->
			feed.inflate()

			feed.validateRedirects()
			feed.messages.warnings.should.have.length 0

			feed.addRedirect 'http://www.example.com' for i in [1..3]
			feed.validateRedirects()
			feed.messages.warnings.should.have.length 1


		it 'should warn if the code is not 200', ->
			feed.inflate()

			feed.setCode 200
			feed.validateCode()
			feed.messages.warnings.should.have.length 0

			feed.setCode 123
			feed.validateCode()
			feed.messages.warnings.should.have.length 1


		it 'should warn if the feed has zero items/articles', ->
			feed.inflate()
			feed.validateItems()
			feed.messages.warnings.should.have.length 1


		it 'should not warn if you have between 1-10 items (inclusively)', ->
			feed.inflate()
			feed.addItem new FeedItem for i in [1..5]
			feed.validateItems()
			feed.messages.warnings.should.have.length 0


		it 'should warn if you have more than 10 items', ->
			feed.inflate()
			feed.addItem new FeedItem for i in [1..11]
			feed.validateItems()
			feed.messages.warnings.should.have.length 1


		it 'should give an error if no meta info was recieved, however unlikely', ->
			feed.inflate()
			feed.validateMeta()
			feed.messages.errors.should.have.length 1
