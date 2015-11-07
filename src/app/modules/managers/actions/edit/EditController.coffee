# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
EditView = require './views/EditView'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there's an addittional independent channel.
moduleChannel = require '../../moduleChannel'


###
Managers module edit controller
===============================

Controller responsible for Managers editing

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
module.exports = class EditController extends ViewController

  initialize: (options) ->
    { model, id, collection } = options

    # if no model provided, retrieve it
    model or= @getModel id, collection

    # Get the layout
    # Some controllers of this module share the same layout,
    # so avoid re-rendering the entire view and update only the required regions
    layout = moduleChannel.request 'layout:get'

    # create the view
    view = @getView model

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    # @listenTo view, 'show', =>
    moduleChannel.trigger 'section:changed', @getActionMetadata model

    # wrap it into a form component
    formView = @wrapViewWithForm(view, model, collection)

    # render
    @show formView,
      loading:
        entities: [model, collection]
      region: layout.getRegion 'main'



  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @param  {Model}
  @return {Object}
  ###
  getActionMetadata: (model) ->
    meta = moduleChannel.request 'meta'

    {
      module:
        name: meta.title()
        url: meta.rootUrl

      item:      model.get 'title'
      action:    i18n.t 'Edit'
    }



  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Model} data
  @return {View}
  ###
  getView: (data) ->
    new EditView
      model: data



  ###
  Load the model

  The controller usually receives a fully fetched model, but in some
  circumstances (for example a page refresh) it could receive just
  the model ID

  @param {String}     id                 The model ID
  @param {Collection} originalCollection The collection the model should belong to
  ###
  getModel: (id, originalCollection) ->
    model = @appChannel.request 'managers:entity', id

    # When loading this directly (for example, refreshing the page)
    # the model and the collection on the sidebar get loaded separatelly
    # so the model loaded here and the one on the sidebar are different.
    # In that situation, update the original once the local one is saved.
    model.once 'updated', ->
      original = originalCollection.get model.id
      if original
        original.set model.attributes
      else
        originalCollection.add model

    model



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
      onFormDelete:  ->
        if window.confirm(i18n.t 'Are you sure you want to delete this?')
          moduleChannel.trigger 'delete:manager', model



  ###
  Callback executed when the form is closed
  ###
  formActionDone: (success = false) ->
    if success
      flashMessage = i18n.t 'kb:::Category successfully updated'
      @appChannel.request 'flash:success', flashMessage
    @region.empty()
    moduleChannel.trigger 'done:manager'
