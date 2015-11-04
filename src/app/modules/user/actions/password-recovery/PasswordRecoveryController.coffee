# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
PasswordRecoverView = require './views/PasswordRecoverView'

# Radio channels:
usersChannel = require '../../moduleChannel'


# Password recovery controller
#
module.exports = class PasswordRecoveryController extends ViewController

  initialize: (options) ->

    # retrieve the model
    model = @getModel()

    # create the view
    view = @getView model

    # wrap it into a form component
    formView = @wrapViewWithForm view, model

    # render
    @show formView


  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Model} data
  @return {View}
  ###
  getView: (data) ->
    new PasswordRecoverView
      model: data



  ###
  Load the model
  ###
  getModel: () ->
    @appChannel.request 'user:passwordRecovery:entity'


  ###
  Form setup

  Wraps the view inside a FormComponent that handles the
  serializing/deserializing, validation and other stuff.

  @param {View}       view
  @param {Model}      model
  ###
  wrapViewWithForm: (view, model) ->
    @appChannel.request 'form:component', view,
      formCssClass:  'login'
      onFormCancel:  => @formActionDone()
      onFormSuccess: => @formActionDone(true)



  ###
  Callback executed when the form is closed
  ###
  formActionDone: (success = false) ->
    if success
      flashTitle   = i18n.t 'user::Password reset request successfully created'
      flashMessage = i18n.t 'user::You will receive a mail with instructions to reset the password'
      @appChannel.request 'flash:success', flashMessage, flashTitle

      # redirect to login
      usersChannel.trigger 'redirect:login'
