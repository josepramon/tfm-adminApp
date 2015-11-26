# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Controller     = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
ShowController = require './actions/show/ShowController'




###
Tickets module main controller
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

  show: ->
    new ShowController()



  ###
  Event handler invoked when the router inactive (the loaded route
  matches any of the routes deffined in that router)
  ###
  onActive: ->
    # temporally restrincting the access to the whole module
    # this could be implemented also on a specific routes
    @_restrictToAuthorisedUsers()
    console.log 'Tickets active'

  ###
  Event handler invoked when the router becomes inactive (the loaded route
  no longer matches any of the routes deffined in that router)
  ###
  onInactive: ->
    console.log 'Tickets inactive'



  _restrictToAuthorisedUsers: ->
    @appChannel.request 'auth:requireAuth', null, false
