# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
AccountActivationView = require './views/AccountActivationView'

# Radio channels:
usersChannel = require '../../moduleChannel'


# Account activation controller
#
module.exports = class SetPasswordController extends ViewController

  initialize: (options) ->
    { model, id, collection, tagsCollection, categoriesCollection } = options

    # if no model provided, retrieve it
    model or= @getModel id

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
    new AccountActivationView
      model: data



  ###
  Load the model
  ###
  getModel: (id) ->
    @appChannel.request 'user:accountActivation:entity', id


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
      flashMessage = i18n.t 'user::Account has been activated successfully'
      @appChannel.request 'flash:success', flashMessage

    # redirect to login
    usersChannel.trigger 'redirect:login'
