# Dependencies
# -----------------------

Marionette = require 'backbone.marionette'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
View = require './views/UserWidget'




###
User widget view controller
==================================

@class
@augments ViewController

###
module.exports = class UserWidgetController extends ViewController

  ###
  Controller initialization
  ###
  initialize: ->
    view = @getView()

    @listenTo @appChannel, 'auth:unauthenticated', ->
      view.model = null
      view.render()

    @listenTo @appChannel, 'auth:authenticated', =>
      model      = @getUserModel()
      view.model = model
      Marionette.bindEntityEvents view, model, view.modelEvents
      view.render()

    # render
    @show view


  # Aux
  # -----------------

  ###
  View getter

  @return {View}
  ###
  getView: ->
    new View()


  ###
  User model getter

  @return {Session} the session model
  ###
  getUserModel: ->
    user    = null
    session = @appChannel.request 'user:session:entity'

    if session
      user = session.get 'user'

    user
