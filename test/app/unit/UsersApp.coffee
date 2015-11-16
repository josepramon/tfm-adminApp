describe 'AdminApp', ->
  App   = require 'AdminApp'
  sinon = require 'sinon'

  app    = null
  server = null


  before (done) ->
    server = sinon.fakeServer.create()
    server.respondWith 'GET', /\/assets\/locales\/*/, [
      200
      { 'Content-Type': 'application/json' }
      '{}'
    ]
    done()


  after (done) ->
    server.restore()
    done()


  beforeEach (done) ->
    app = new App
    done()


  afterEach (done) ->
    app._destroy()
    done()


  it 'should expose an "environment"', (done) ->
    expect(app).to.have.property 'environment'

    # check the default value
    expect(app.environment).to.be.equal 'production'

    # check the supplied value
    app = null
    app = new App
      environment: 'development'

    expect(app.environment).to.be.equal 'development'
    done()


  it 'should have a rootRoute', (done) ->
    expect(app).to.have.property 'rootRoute'
    done()


  describe 'Application modules', ->
    it 'should have some modules', (done) ->
      expect(app).to.have.property 'submodules'
      expect(Object.keys app.submodules).to.have.length.above 1
      done()


    # 'general' modules
    it 'should have an "Entities" module', (done) ->
      expect(app.submodules).to.have.property 'Entities'
      # Marionette also attaches the modules directly to the application obj
      expect(app).to.have.property 'Entities'
      done()


    it 'should have an "Utilities" module', (done) ->
      expect(app.submodules).to.have.property 'Utilities'
      expect(app).to.have.property 'Utilities'
      done()


    it 'should have an "Components" module', (done) ->
      expect(app.submodules).to.have.property 'Components'
      expect(app).to.have.property 'Components'
      done()


  describe 'Application regions', ->

    # application regions have been deprecated in favor of layouts
    it 'should not have regions attached to the app', (done) ->
      expect(app).to.not.have.property 'regions'
      done()

    it 'should have a main layout', (done) ->
      expect(app).to.have.property 'layout'
      expect(app.layout).not.to.be.null
      expect(app.layout.constructor.name).to.be.equal 'AppLayout'
      expect(app.layout).to.have.property 'regions'
      expect(Object.keys app.layout.regions).to.have.length.above 1
      done()
