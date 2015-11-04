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
# there's an addittional independent channel.
moduleChannel    = require './moduleChannel'




###
Managers module main controller
=======================================

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
    new ListController
      collection: @getCollection()


  create: ->
    new CreateController
      collection: @getCollection()


  ###
  @param {int}      id       model id
  @param {Manager}  manager model
  ###
  edit: (id, manager) ->
    new EditController
      id:         id
      model:      manager
      collection: @getCollection()



  # Aux methods
  # ------------------------

  ###
  Collection getter
  ###
  getCollection: ->
    unless @collection
      @collection = @appChannel.request 'managers:entities'
    @collection


  ###
  Event handler invoked when the router becomes inactive (the loaded route
  no longer matches any of the routes deffined in that router)
  ###
  onInactive: -> delete @collection
