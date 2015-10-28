# Dependencies
# -----------------------

Backbone = require 'backbone'

# Base class (extends Marionette.Controller)
Controller     = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
ShowController = require './actions/show/ShowController'




###
Blog dashboard module main controller
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
  This is a special method due to this controller being mounted at the root url
  It's invoked when the root module url is called
  ###
  redirectToRoot: ->
    Backbone.history.navigate('', { trigger: true })



  ###
  Event handler invoked when the router inactive (the loaded route
  matches any of the routes deffined in that router)
  ###
  onActive: ->
    # warning: will not catch roor route (because does not use the module prefix)
    console.log 'KnowledgeBase active'

  ###
  Event handler invoked when the router becomes inactive (the loaded route
  no longer matches any of the routes deffined in that router)
  ###
  onInactive: ->
    console.log 'KnowledgeBase inactive'
