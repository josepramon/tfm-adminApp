# Dependencies
# -----------------------

# Libs/generic stuff:
_              = require 'underscore'
i18n           = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# Helpers
StatusesHelper = require 'msq-appbase/lib/helpers/CategorizableModelControllerHelper'

# The view
CreateView     = require './views/CreateView'

# Radio channels:
ticketsChannel  = require '../../../../moduleChannel'
StatusesChannel = require '../../moduleChannel'


###
Statuses module create controller
====================================

Controller responsible for Statuses creation

This controller is responsible for instantiating views,
fetching entities (models/collections) and ensuring views
are configured properly.

When those views emit evnts throughout their lifecycle or
when something in particular happens which is important to
the application, this controller will listen for those
events and generally bubble those events up to the parent
module.

@class
@augments ViewController

###
module.exports = class CreateController extends ViewController

  initialize: (options) ->
    model      = @getModel()
    collection = options.collection

    # create the view
    view = @getView model

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    @listenTo view, 'show', =>
      ticketsChannel.trigger 'section:changed', @getActionMetadata()

    # wrap it into a form component
    formView = @wrapViewWithForm(view, model, collection)

    # render
    @show formView,
      loading:
        entities: [model, collection]



  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @return {Object}
  ###
  getActionMetadata: () ->
    meta = StatusesChannel.request 'meta'
    parentMeta = ticketsChannel.request 'meta'

    {
      parentModule:
        name: parentMeta.title()
        url:  parentMeta.rootUrl

      module:
        name: meta.title()
        url: meta.rootUrl

      action:    i18n.t 'Create'
    }



  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Model} model
  @return {View}
  ###
  getView: (model) ->
    new CreateView
      model: model


  ###
  Load the model
  ###
  getModel: ->
    @appChannel.request 'new:tickets:statuses:entity'



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
      flashMessage = i18n.t 'tickets:::Status successfully created'
      @appChannel.request 'flash:success', flashMessage
    @region.empty()
    StatusesChannel.trigger 'done:tickets:status'
