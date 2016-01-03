# Dependencies
# -----------------------

# Libs/generic stuff:
_               = require 'underscore'
i18n            = require 'i18next-client'

# Base class (extends Marionette.Module)
Module          = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router          = require './ModuleRouter'
RouteController = require './ModuleController'

# Radio channels:
moduleChannel   = require './moduleChannel'




###
Tickets Statuses module
=================================

Tickets submodule responsible of statuses handling

@class
@augments Module

###
module.exports = class TicketsStatusesApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t 'modules::TicketsStatuses'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'tickets/statuses'

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

    # module metadata getter
    moduleChannel.reply 'meta', => @meta



  # Module events
  # ------------------------

  ###
  Event handler executed after the module has been started

  This module has many 'actions' (create, edit...) linked between
  them. Instead of deffining the navigation mechanisms on every 'action',
  just deffine them all here.
  ###
  onStart: ->
    @listenTo moduleChannel, 'create:tickets:status', =>
      @create()
      @app.navigate "/#{@meta.rootUrl}/new"

    @listenTo moduleChannel, 'edit:tickets:status', (model) =>
      @app.navigate "/#{@meta.rootUrl}/#{model.id}/edit"
      @edit model.id, model

    @listenTo moduleChannel, 'delete:tickets:status', (model) =>
      @destroyStatus model, =>
        @app.navigate "/#{@meta.rootUrl}", { trigger:true }

    # done is executed when any of the previous actions finishes or is canceled
    @listenTo moduleChannel, 'done:tickets:status', =>
      @app.navigate "/#{@meta.rootUrl}", { trigger:true }



  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->
    @stopListening()



  # Module API
  # ------------------------

  ###
  List the statuses
  ###
  list: -> moduleController.list()


  ###
  Edit some status

  @param {Integer}  id      model id
  @param {Status} model   status model
  ###
  edit: (id, model) -> moduleController.edit id, model


  ###
  Create a new status
  ###
  create: -> moduleController.create()


  ###
  Status deletion

  @param {Status} model
  @param {Function} callback
  ###
  destroyStatus: (model, callback) ->
    model.destroy
      success: (model, response) =>
        flashMessage = i18n.t 'tickets:::Status successfully deleted'
        @appChannel.request 'flash:success', flashMessage
        if _.isFunction callback then callback(model, response)





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
