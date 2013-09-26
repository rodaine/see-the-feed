should = require('should')
Messageable = require('../../models/messageable')

describe 'Models', ->
	describe 'Messageable', ->
		msg = undefined


		beforeEach ->
			msg = new Messageable


		it 'should be devoid of messages at construction', ->
			should.not.exist msg.messages


		it 'should log error messages', ->
			err1 = 'This is an error'
			err2 = 'This is another error'

			msg.addError err1
			
			should.exist msg.messages
			should.exist msg.messages.errors
			
			msg.messages.errors.should.be.an.instanceOf Array
			msg.messages.errors.should.have.length 1

			msg.addError err2
			msg.messages.errors.should.have.length 2

			msg.messages.errors.should.include err1
			msg.messages.errors.should.include err2


		it 'should log warning messages', ->
			wrn = 'This is a warning'
			
			msg.addWarning wrn

			should.exist msg.messages.warnings
			msg.messages.warnings.should.have.length 1
			msg.messages.warnings.should.include wrn


		it 'should log notice messages', ->
			ntc = 'This is a notice'

			msg.addNotice ntc

			should.exist msg.messages.notices
			msg.messages.notices.should.have.length 1
			msg.messages.notices.should.include ntc
