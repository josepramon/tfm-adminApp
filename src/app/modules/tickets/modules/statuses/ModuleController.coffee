# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Controller       = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
ListController   = require './actions/list/ListController'
EditController   = require './actions/edit/EditController'
CreateController = require './actions/create/CreateController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the statuses module, and the parent
# module channel.
moduleChannel  = require './moduleChannel'
ticketsChannel = require '../../moduleChannel'




###
Tickets statuses module main controller
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
        region:     @getRegion 'main'
        collection: @getCollection()


  create: ->
    if @_hasPrivileges()
      new CreateController
        region:     @getRegion 'main'
        collection: @getCollection()


  ###
  @param {int}    id     model id
  @param {Status} status model
  ###
  edit: (id, status) ->
    if @_hasPrivileges()
      new EditController
        id:         id
        model:      status
        collection: @getCollection()
        region:     @getRegion 'main'



  # Aux methods
  # ------------------------

  ###
  Collection getter
  ###
  getCollection: ->
    unless @collection
      @collection = @appChannel.request 'tickets:statuses:entities'
    @collection


  ###
  Region getter

  @param  {String} region  The region name
  @return {Marionette.Region}
  ###
  getRegion: (region) ->
    layout = ticketsChannel.request 'layout:get'
    layout.getRegion region


  ###
  Event handler invoked when the router becomes inactive (the loaded route
  no longer matches any of the routes deffined in that router)
  ###
  onInactive: -> delete @collection


  ###
  Access control
  ###
  _hasPrivileges: ->
    permissions = {tickets: {actions: {manageStatuses: true}}}
    @appChannel.request 'auth:requireAuth', permissions, false
