# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Module)
Module = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Entities         = require './entities'
moduleChannel    = require './moduleChannel'
Router           = require './ModuleRouter'
RouteController  = require './ModuleController'
LayoutController = require './layout/LayoutController'




###
Managers (agents) module
============================

Module responsible of managing 'managers' or 'agents', users with
access too the dashboard with restricted privileges.

@class
@augments Module

###
module.exports = class ManagersApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t 'modules::Managers'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'managers'

    ###
    @property {String} icon (font awesome class) that identifies the module
    ###
    icon: 'users'

    ###
    @property {Boolean} show the module in the app navigation
    ###
    showInModuleNavigation: true

    ###
    @property {String} locale namespace needed by this module (will be autoloaded)
    ###
    localeNS : 'managers'

    ###
    @property {Boolean} let the main app start/stop this whenever appropiate (for example on auth events)
    ###
    stopable: true



  ###
  Controller used by the module router

  @type {ModuleController}
  @private
  ###
  moduleController = null



  ###
  Module initialization
  ###
  initialize: ->

    # setup the module components
    @initModuleRouter()

    # register the module entities
    @app.module 'Entities.Managers', Entities

    # initialize the shared layout
    @initModuleLayout()

    # module metadata getter
    moduleChannel.reply 'meta', => @meta




  # Aux methods
  # ------------------------

  ###
  Setup the module router
  ###
  initModuleRouter: ->
    moduleController = new RouteController()

    moduleRouter = new Router
      controller: moduleController
      rootUrl:    @meta.rootUrl



  # Module events
  # ------------------------

  ###
  Event handler executed after the module has been started

  This module has many 'actions' (create, edit...) linked between
  them. Instead of deffining the navigation mechanisms on every 'action',
  just deffine them all here.
  ###
  onStart: ->
    @listenTo moduleChannel, 'create:manager', =>
      @create()
      @app.navigate "/#{@meta.rootUrl}/new"

    @listenTo moduleChannel, 'edit:manager', (model) =>
      @app.navigate "/#{@meta.rootUrl}/#{model.id}/edit"
      @edit model.id, model

    @listenTo moduleChannel, 'delete:manager', (model) =>
      @destroyAgent model, =>
        @app.navigate "/#{@meta.rootUrl}", { trigger:true }

    # done is executed when any of the previous actions finishes or is canceled
    @listenTo moduleChannel, 'done:manager', =>
      @app.navigate "/#{@meta.rootUrl}", { trigger:true }



  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->
    @stopListening()


  ###
  Initialize the module layout
  ###
  initModuleLayout: ->
    layout = new LayoutController()




  # Module API
  # ------------------------

  ###
  List the agents
  ###
  list: -> moduleController.list()


  ###
  Edit some agent

  @param {Integer}  id   model id
  @param {Agent} model   agent model
  ###
  edit: (id, model) -> moduleController.edit id, model


  ###
  Create a new agent
  ###
  create: -> moduleController.create()


  ###
  Agent deletion

  @param {Agent}    model
  @param {Function} callback
  ###
  destroyAgent: (model, callback) ->
    model.destroy
      success: (model, response) =>
        flashMessage = i18n.t 'managers:::Agent successfully deleted'
        @appChannel.request 'flash:success', flashMessage
        if _.isFunction callback then callback(model, response)

