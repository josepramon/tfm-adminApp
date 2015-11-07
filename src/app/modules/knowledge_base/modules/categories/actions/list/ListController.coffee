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
# there're two addittional independent channels, the
# channel for the Categories module, and the parent
# module channel.
kbChannel         = require '../../../../moduleChannel'
categoriesChannel = require '../../moduleChannel'




###
Knowledge Base categories module list controller
=================================================

Controller responsible for categories listing.

@class
@augments ViewController

###
module.exports = class ListController extends ViewController

  initialize: (options) ->

    # get the collection
    collection = options.collection

    # create the view
    listView = @getView collection

    # setup events
    @listenTo listView, 'show', =>
      @setupViewEvents listView

    # render
    @show listView,
      loading:
        entities: collection

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    kbChannel.trigger 'section:changed', getActionMetadata()


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
    meta = categoriesChannel.request 'meta'
    parentMeta = kbChannel.request 'meta'

    {
      parentModule:
        name: parentMeta.title()
        url:  parentMeta.rootUrl

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
    @listenTo view, 'edit:kb:category',   (args) -> @API.editCategory args.model
    @listenTo view, 'delete:kb:category', (args) -> @API.deleteCategory args.model
    @listenTo view, 'create:kb:category',        -> @API.createCategory()


  API:
    ###
    Callback executed when the edit button on the childviews is clicked

    Bubbles up the event to the module so it can take the necessary actions

    @param {Category} model
    ###
    editCategory: (model) -> categoriesChannel.trigger 'edit:kb:category', model


    ###
    Callback executed when the delete button on the childviews is clicked

    Bubbles up the event to the module so it can take the necessary actions

    @param {Category} model
    ###
    deleteCategory: (model) -> categoriesChannel.trigger 'delete:kb:category', model


    ###
    Callback executed when the create button on the list is clicked

    Bubbles up the event to the module so it can take the necessary actions
    ###
    createCategory: -> categoriesChannel.trigger 'create:kb:category'
