# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
AccountView = require './views/ProfileView'

# Radio channels:
usersChannel = require '../../moduleChannel'


# User module profile controller
#
module.exports = class ProfileController extends ViewController

  initialize: (options) ->

    # retrieve the model
    model = @getModel()

    # Get the layout
    # Some controllers of this module share the same layout,
    # so avoid re-rendering the entire view and update only the required regions
    layout = usersChannel.request 'layout:get'

    # create the view
    view = @getView model

    # wrap it into a form component
    formView = @wrapViewWithForm view, model

    # render
    @show formView, region: layout.getRegion 'main'

    # this action has a shared layout with common regions
    # (the header), so after loading the section, it may be
    # necessary to update other regions
    usersChannel.trigger 'section:changed', @getActionMetadata()


  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Model} data
  @return {View}
  ###
  getView: (data) ->
    new AccountView
      model: data



  ###
  Load the model
  ###
  getModel: () ->
    session = @appChannel.request 'user:session:entity'
    if session
      return session.get 'user'
    else
      null


  ###
  Form setup

  Wraps the view inside a FormComponent that handles the
  serializing/deserializing, validation and other stuff.

  @param {View}       view
  @param {Model}      model
  @param {Collection} collection
  ###
  wrapViewWithForm: (view, model, collection) ->
    @appChannel.request 'form:component', view,
      collection:       collection
      onFormCancel:  => @formActionDone()
      onFormSuccess: => @formActionDone(true)



  ###
  Callback executed when the form is closed
  ###
  formActionDone: (success = false) ->
    if success
      flashMessage = i18n.t 'user::Profile successfully updated'
      @appChannel.request 'flash:success', flashMessage


  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @param  {Model}
  @return {Object}
  ###
  getActionMetadata: () ->
    meta = usersChannel.request 'meta'

    {
      module:
        name: meta.title()
        url: meta.rootUrl

      action: i18n.t 'user::Profile'
    }
