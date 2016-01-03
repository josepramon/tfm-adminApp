# Dependencies
# -----------------------

# Libs/generic stuff:
_        = require 'underscore'
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
EditView = require './views/EditView'

# Radio channels:
ticketsChannel = require '../../../../moduleChannel'
moduleChannel  = require '../../moduleChannel'


###
Tickets module edit controller
====================================

@class
@augments ViewController

###
module.exports = class EditController extends ViewController

  initialize: (options) ->
    { model, categoriesCollection } = options

    # create the view
    view = @getView model, categoriesCollection

    # wrap it into a form component
    formView = @wrapViewWithForm(view, model, categoriesCollection)

    @listenTo formView, 'form:submit', @processFormData

    # render
    @show formView,
      loading:
        entities: [model, categoriesCollection]

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    ticketsChannel.trigger 'section:changed', getActionMetadata model

    # save some references
    @model = model
    @categoriesCollection = categoriesCollection



  ###
  View getter

  Instantiates this controller's view
  passing to it any required data
  @param {Model} model
  @param {Collection} categoriesCollection
  @return {View}
  ###
  getView: (model, categoriesCollection) ->
    new EditView
      model:      model
      collection: model.get 'comments'
      categories: categoriesCollection


  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @param  {Model}
  @return {Object}
  ###
  getActionMetadata = (model) ->
    meta = moduleChannel.request 'meta'
    parentMeta = ticketsChannel.request 'meta'

    {
      parentModule:
        name: parentMeta.title()
        url:  parentMeta.rootUrl

      module:
        name: meta.title()
        url: meta.rootUrl

      item:      model.id
      action:    i18n.t 'Edit'
    }


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
      flashMessage = i18n.t 'tickets:::Ticket successfully updated'
      @appChannel.request 'flash:success', flashMessage
      moduleChannel.trigger 'done:uncategorised:ticket'


  ###
  Form submit handler

  Preprocess the data before the generic handlers are executed
  ###
  processFormData: (data) =>
    # process the category
    data.category = @categoriesCollection.get data.category
