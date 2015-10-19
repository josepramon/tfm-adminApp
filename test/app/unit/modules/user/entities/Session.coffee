describe 'modules/user/entities/Session', ->
  $              = require 'jquery'
  mockjax        = require('jquery-mockjax')($)
  SessionModel   = require 'modules/user/entities/Session'
  SessionFixture = require 'test/app/fixtures/entities/user/Session'


  before (done) ->
    $.mockjaxSettings.contentType = 'text/json'
    $.mockjaxSettings.logging     = false

    # mock the API server
    $.mockjax (requestSettings) ->

      if /^\/api\/auth\//.test requestSettings.url
        return response: (origSettings) ->
          # check if there's a token (the token content does not matter)
          unless requestSettings.headers['authorization'] and
          /^Bearer\ .+/.test requestSettings.headers['authorization']

            @status = 401
            @responseText = 'You are not authorized'
            return

          # token refresh
          if requestSettings.type is 'PUT'
            @responseText = JSON.stringify(new SessionFixture)
          # any other call
          else
            @responseText = '{}'

      # This url should only be called in case of error IN THE TESTS
      # (in the actual API is used)
      # Handler deffined only to supress some mockjax warns
      if /^\/api\/auth/.test requestSettings.url
        return response: (origSettings) ->
          @status = 404

      # no url match
      return

    done()


  after (done) ->
    $.mockjax.clear()
    done()


  it 'should have an idAttribute', (done) ->
    model = new SessionModel

    expect(model).to.have.property('idAttribute')
    expect(model.idAttribute).to.not.be.null
    done()


  it 'should have a urlRoot', (done) ->
    model = new SessionModel

    expect(model).to.have.property('urlRoot')
    expect(model.urlRoot).not.to.be.null
    done()


  it 'should have certain defaults', (done) ->
    model = new SessionModel

    expect(model.get 'id').not.to.be.undefined
    expect(model.get 'token').not.to.be.undefined
    expect(model.get 'token_iat').not.to.be.undefined
    expect(model.get 'token_exp').not.to.be.undefined
    expect(model.get 'username').not.to.be.undefined
    expect(model.get 'email').not.to.be.undefined

    expect(model.get 'id').to.be.null
    expect(model.get 'token').to.be.null
    expect(model.get 'token_iat').to.be.null
    expect(model.get 'token_exp').to.be.null
    expect(model.get 'username').to.equal ''
    expect(model.get 'email').to.equal ''
    done()


  it 'should take fixture json', (done) ->
    fixture = new SessionFixture
    model   = new SessionModel fixture

    expect(model.get 'id').to.equal fixture.id
    expect(model.get 'token').to.equal fixture.token
    expect(model.get 'token_iat').to.equal fixture.token_iat
    expect(model.get 'token_exp').to.equal fixture.token_exp
    expect(model.get 'username').to.equal fixture.username
    expect(model.get 'email').to.equal fixture.email
    done()


  describe 'isExpired', ->
    it "should return true it there's no token expiry date", (done) ->
      model = new SessionModel
      expect(model.isExpired()).to.be.true
      done()


    it "should return false it there's a token with a expiry date in the future", (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture
      expect(model.isExpired()).to.be.false
      done()


    it "should return true it there's a token with a expiry date in the past", (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture

      # override the expiry date
      exp = parseInt( (new Date('01/01/1980').getTime() / 1000), 10 )
      model.set 'token_exp', exp
      expect(model.isExpired()).to.be.true
      done()


  describe 'isAuthenticated', ->
    it "should return false it there's no token", (done) ->
      model = new SessionModel
      expect(model.isAuthenticated()).to.be.false
      done()


    it "should return true it there's a token with a expiry date in the future", (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture
      expect(model.isAuthenticated()).to.be.true
      done()


    it "should return false it there's a token with a expiry date in the past", (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture

      # override the expiry date
      exp = parseInt( (new Date('01/01/1980').getTime() / 1000), 10 )
      model.set 'token_exp', exp
      expect(model.isAuthenticated()).to.be.false
      done()


    it 'should attach an auth header to all the API calls when authenticated', (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture

      $.get(model.url()).done(->
        done()
      ).fail ->
        should.fail()


  describe 'verify', ->
    it 'should execute the success callback if the session is valid', (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture

      successCB = ->
        done()
      errorCB = ->
        should.fail()
        done()

      model.verify successCB, errorCB


    it 'should execute the error callback if the session is not valid', (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture

      model.unset 'token'

      successCB = ->
        should.fail()
      errorCB = ->
        done()

      model.verify successCB, errorCB


  describe 'renew', ->
    it 'should execute the success callback if the session is still valid', (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture

      successCB = ->
        done()
      errorCB = ->
        should.fail()

      model.renew successCB, errorCB


    it 'should execute the error callback if the session is not valid', (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture

      model.unset 'token'

      successCB = ->
        should.fail()
      errorCB = ->
        done()

      model.renew successCB, errorCB


    it 'should update the session data after a successful renewal', (done) ->
      fixture = new SessionFixture
      model   = new SessionModel fixture

      successCB = ->
        expect(model.get 'token').to.not.equal(fixture.token)
        # don't check the dates: the new token_iat and token_exp
        # should be greater than the previous ones, but on the tests
        # that data is generated randomly
        done()
      errorCB = ->
        should.fail()

      model.renew successCB, errorCB
