# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Controller       = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
ListController   = require './actions/list/ListController'
EditController   = require './actions/edit/EditController'

# Radio channels:
moduleChannel  = require './moduleChannel'
ticketsChannel = require '../../moduleChannel'




###
Tickets categories module main controller
=================================================

The class forwards the calls deffined in a module router to the appropiate
CRUD methods in the speciallised controllers (each controller is only responsible
for a task, like editing a record, or listing them).

@class
@augments Controller

###
module.exports = class ModuleController extends Controller


  #  Controller API:
  #  --------------------
  #
  #  Methods used by the router (and may be called directly from the module, too)

  list: ->
    if @_hasPrivileges()
      new ListController
        collection: @getCollection(true)
        region:     @getRegion 'main'


  ###
  Edit a ticket

  @param {String}   ticketId  Ticket id
  @param {Category} ticket    Ticket model
  ###
  edit: (ticketId, ticket) ->
    if @_hasPrivileges()
      ticket or= @getTicketModel ticketId

      new EditController
        id:                   ticketId
        model:                ticket
        collection:           @getCollection()
        categoriesCollection: @getCategoriesCollection()
        region:               @getRegion 'main'



  # Aux methods
  # ------------------------

  ###
  Collection getter
  ###
  getCollection: (refresh = false) ->
    if refresh or !@collection
      @collection = @appChannel.request 'tickets:uncategorised:entities',
        filters: ['closed:false','assigned:true']
    @collection


  ###
  Categories collection getter
  ###
  getCategoriesCollection: ->
    unless @categoriesCollection
      @categoriesCollection = @appChannel.request 'tickets:categories:entities'
    @categoriesCollection


  ###
  Retrieve a model

  If there's a cached collection containing the model, that model is returned.
  Otherwise, the model is fetched from the server
  ###
  getTicketModel: (id) ->
    if @collection and @collection.models.length
      model = @collection.get id
      if model then return model

    # if not found, load it from the server
    @appChannel.request 'tickets:uncategorised:entity', id


  ###
  Region getter

  @param  {String} region  The region name
  @return {Marionette.Region}
  ###
  getRegion: (region) ->
    layout = ticketsChannel.request 'layout:get'
    layout.getRegion region


  # Events
  # ------------------------

  ###
  Event handler invoked when the router becomes inactive (the loaded route
  no longer matches any of the routes deffined in that router)
  ###
  onInactive: ->
    delete @collection
    delete @categoriesCollection


  ###
  Access control
  ###
  _hasPrivileges: ->
    permissions = {tickets: {actions: {uncategorised: true}}}
    @appChannel.request 'auth:requireAuth', permissions, false
