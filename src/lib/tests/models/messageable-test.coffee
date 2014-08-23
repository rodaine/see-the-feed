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

			msg.messages.errors.should.containEql err1
			msg.messages.errors.should.containEql err2


		it 'should log warning messages', ->
			wrn = 'This is a warning'

			msg.addWarning wrn

			should.exist msg.messages.warnings
			msg.messages.warnings.should.have.length 1
			msg.messages.warnings.should.containEql wrn


		it 'should log notice messages', ->
			ntc = 'This is a notice'

			msg.addNotice ntc

			should.exist msg.messages.notices
			msg.messages.notices.should.have.length 1
			msg.messages.notices.should.containEql ntc


		it 'should be inflatable to include empty but defined versions of all message levels', ->
			msg.inflate()

			should.exist msg.messages
			should.exist msg.messages.errors
			should.exist msg.messages.warnings
			should.exist msg.messages.notices

			msg.messages.errors.should.have.length 0
			msg.messages.warnings.should.have.length 0
			msg.messages.notices.should.have.length 0


		it 'should not delete preexisting messages on inflate', ->
			err = 'This is an error'

			msg.addError err
			msg.inflate()

			msg.messages.errors.should.have.length 1
			msg.messages.errors.should.containEql err

