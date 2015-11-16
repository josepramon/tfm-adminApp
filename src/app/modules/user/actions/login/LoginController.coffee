_              = require 'underscore'
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'
LoginView      = require './views/LoginView'


# User module login controller
module.exports = class LoginController extends ViewController

  # Controller initialization
  #
  initialize: ->
    loginModel = @getLoginModel()
    loginView  = @getLoginView loginModel
    formView   = @appChannel.request 'form:component', loginView,
      formCssClass: 'login'

    # when successfully logged in, create/update the session with the returned values
    @listenTo loginModel, 'created', =>
      session = @getSessionModel()
      session.save _.omit loginModel.attributes, 'username', 'password'
      loginModel = null
      @appChannel.trigger 'auth:authenticated'

    # render the login form
    @show formView


  # Session model getter
  #
  # @return {Session} the session model
  #
  getSessionModel: ->
    @appChannel.request 'user:session:entity'


  # Login model getter
  #
  # @return {UserLogin} the login model
  #
  getLoginModel: ->
    model = @appChannel.request 'user:login:entity'
    @setApplicationId model
    model


  # Login view getter
  #
  # @return {LoginView} the login form view
  #
  getLoginView: (model) ->
    new LoginView
      model: model


  # App ID setter
  #
  # the application may have an ID
  # this id is used in the API to restrict some actions
  # or to identify where the request comes from
  setApplicationId: (model) ->
    appId = @appChannel.request 'application:id'
    if appId
      model.set
        appID: appId
