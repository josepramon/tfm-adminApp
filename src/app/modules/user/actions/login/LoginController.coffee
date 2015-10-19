_              = require 'underscore'
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'
LoginView      = require './LoginView'


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
      session.save _.omit loginModel.attributes, 'password'
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
    @appChannel.request 'user:login:entity'


  # Login view getter
  #
  # @return {LoginView} the login form view
  #
  getLoginView: (model) ->
    new LoginView
      model: model
