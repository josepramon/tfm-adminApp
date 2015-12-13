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
ticketsChannel  = require '../../../../moduleChannel'
statusesChannel = require '../../moduleChannel'




###
Knowledge Base statuses module list controller
=================================================

Controller responsible for statuses listing.

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
    ticketsChannel.trigger 'section:changed', getActionMetadata()


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
    meta = statusesChannel.request 'meta'
    parentMeta = ticketsChannel.request 'meta'

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
    @listenTo view, 'edit:tickets:status',         (args) -> @API.editStatus args.model
    @listenTo view, 'delete:tickets:status',       (args) -> @API.deleteStatus args.model
    @listenTo view, 'create:tickets:status',              -> @API.createStatus()
    @listenTo view, 'showArticles:tickets:status', (args) -> @API.showRelatedArticles args.model


  API:
    ###
    Callback executed when the edit button on the childviews is clicked

    Bubbles up the event to the module so it can take the necessary actions

    @param {Status} model
    ###
    editStatus: (model) -> statusesChannel.trigger 'edit:tickets:status', model


    ###
    Callback executed when the delete button on the childviews is clicked

    Bubbles up the event to the module so it can take the necessary actions

    @param {Status} model
    ###
    deleteStatus: (model) -> statusesChannel.trigger 'delete:tickets:status', model


    ###
    Callback executed when the create button on the list is clicked

    Bubbles up the event to the module so it can take the necessary actions
    ###
    createStatus: -> statusesChannel.trigger 'create:tickets:status'


    ###
    Callback executed when the status articles column is clicked

    Bubbles up the event to the module so it can take the necessary actions
    ###
    showRelatedArticles: (model) -> statusesChannel.trigger 'displayArticles:tickets:status', model
