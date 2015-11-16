describe 'modules/user/entities/UserEntities', ->
  Application  = require 'msq-appbase/lib/appBaseComponents/Application'
  Model        = require 'msq-appbase/lib/appBaseComponents/entities/Model'
  UserEntities = require 'modules/user/entities'

  app = null


  before (done) ->
    app = new Application
      channelName: 'AdminApp'

    app.module 'Entities', UserEntities
    done()


  after (done) ->
    app._destroy()
    done()


  it 'should return a Login model when requested', (done) ->
    model = app.channel.request 'user:login:entity'

    expect(model).to.not.be.null
    expect(model.constructor.name).to.be.equal 'UserLogin'
    expect(model).to.be.instanceof Model
    done()


  it 'should return a Session model when requested', (done) ->
    model = app.channel.request 'user:session:entity'

    expect(model).to.not.be.null
    expect(model.constructor.name).to.be.equal 'Session'
    expect(model).to.be.instanceof Model
    done()


  it 'should return always the same Session instance when requested', (done) ->
    model1 = app.channel.request 'user:session:entity'
    model2 = app.channel.request 'user:session:entity'

    expect(model1).to.be.equal model2
    done()
