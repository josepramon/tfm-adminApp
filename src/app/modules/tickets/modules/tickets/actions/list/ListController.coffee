# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The views
ListView   = require './views/ListView'

# Radio channels:
ticketsChannel = require '../../../../moduleChannel'
moduleChannel  = require '../../moduleChannel'


###
Tickets module list controller
============================================

Controller responsible for tickets listing.

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
    @setupViewEvents listView

    # render
    @show listView,
      loading:
        entities: collection

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    ticketsChannel.trigger 'section:changed', getActionMetadata()

    # save a reference to the collection
    @collection = collection




  ###
  Collection custom filter (based on the ticket status)
  ###
  filterByStatus: (closed) ->
    @collection.removeQueryFilter 'closed'
    @collection.addQueryFilter    'closed', closed
    @collection.fetch()

  ###
  Collection custom filter (based on the assigned manager)
  ###
  filterByAssignedManager: (limitToAssignedTickets) ->
    @collection.removeQueryFilter 'assigned'
    @collection.addQueryFilter    'assigned', limitToAssignedTickets
    @collection.fetch()





  # Aux
  # -----------------

  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Collection} collection
  @return {View}
  ###
  getView: (collection) ->
    new ListView
      collection: collection


  ###
  View events setup

  @param {View} view
  ###
  setupViewEvents: (view) =>
    @listenTo view, 'filterByStatus',          @filterByStatus
    @listenTo view, 'filterByAssignedManager', @filterByAssignedManager


  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @return {Object}
  ###
  getActionMetadata = () ->
    meta = moduleChannel.request 'meta'
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
