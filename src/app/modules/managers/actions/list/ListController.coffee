# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
ListView       = require './views/ListView'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there's an addittional independent channel.
moduleChannel = require '../../moduleChannel'




###
Managers module list controller
================================

Controller responsible for Managers listing.

@class
@augments ViewController

###
module.exports = class ListController extends ViewController

  initialize: (options) ->

    # get the collection
    collection = options.collection

    # Get the layout
    # Some controllers of this module share the same layout,
    # so avoid re-rendering the entire view and update only the required regions
    layout = moduleChannel.request 'layout:get'

    # create the view
    listView = @getView collection

    # setup events
    @listenTo listView, 'show', =>
      @setupViewEvents listView

    # render
    @show listView,
      loading:
        entities: collection
      region: layout.getRegion 'main'

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    moduleChannel.trigger 'section:changed', getActionMetadata()


  # Aux
  # -----------------

  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Collection}
  @return {View}
  ###
  getView: (data) ->
    new ListView
      collection: data


  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @return {Object}
  ###
  getActionMetadata = () ->
    meta = moduleChannel.request 'meta'

    {
      module:
        name: meta.title()
        url: meta.rootUrl

      action:    i18n.t 'List'
    }


  ###
  View events setup

  @param {View} view
  ###
  setupViewEvents: (view) =>
    @listenTo view, 'edit:manager',   (args) -> @API.editManager args.model
    @listenTo view, 'delete:manager', (args) -> @API.deleteManager args.model
    @listenTo view, 'create:manager',        -> @API.createManager()


  API:
    ###
    Callback executed when the edit button on the childviews is clicked

    Bubbles up the event to the module so it can take the necessary actions

    @param {Category} model
    ###
    editManager: (model) -> moduleChannel.trigger 'edit:manager', model


    ###
    Callback executed when the delete button on the childviews is clicked

    Bubbles up the event to the module so it can take the necessary actions

    @param {Category} model
    ###
    deleteManager: (model) -> moduleChannel.trigger 'delete:manager', model


    ###
    Callback executed when the create button on the list is clicked

    Bubbles up the event to the module so it can take the necessary actions
    ###
    createManager: -> moduleChannel.trigger 'create:manager'
