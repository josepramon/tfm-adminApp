describe 'modules/user/entities/UserLogin', ->
  UserLogin        = require 'modules/user/entities/UserLogin'
  UserLoginFixture = require 'test/app/fixtures/entities/user/UserLogin'


  it 'should have a url', (done) ->
    model = new UserLogin
    expect(model).to.have.property 'url'
    expect(model.url).not.to.be.null
    done()


  it 'should have certain defaults', (done) ->
    model = new UserLogin

    expect(model.get 'username').not.to.be.undefined
    expect(model.get 'password').not.to.be.undefined
    expect(model.get 'username').to.equal ''
    expect(model.get 'password').to.equal ''
    done()


  it 'should take fixture json', (done) ->
    fixture = new UserLoginFixture
    model   = new UserLogin fixture

    expect(model.get 'username').to.equal fixture.username
    expect(model.get 'password').to.equal fixture.password
    done()


  it 'should require a username', (done) ->
    fixture = new UserLoginFixture
    model   = new UserLogin fixture

    model.unset 'username'
    expect(model.isValid(true)).not.to.be.true

    model.set 'username', fixture.username
    expect(model.isValid(true)).to.be.true
    done()


  it 'should require a password', (done) ->
    fixture = new UserLoginFixture
    model   = new UserLogin fixture

    model.unset 'password'
    expect(model.isValid(true)).not.to.be.true

    model.set 'password', fixture.password
    expect(model.isValid(true)).to.be.true
    done()
