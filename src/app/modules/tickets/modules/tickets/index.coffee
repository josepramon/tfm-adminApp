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
Tickets module
=================================

Tickets submodule responsible of tickets handling

@class
@augments Module

###
module.exports = class TicketsCategoriesApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t 'modules::Tickets'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'tickets'

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
    @listenTo moduleChannel, 'edit:tickets:ticket', (model) =>
      @app.navigate "/#{@meta.rootUrl}/#{model.id}/edit"
      @edit model.id, model

    @listenTo moduleChannel, 'delete:tickets:ticket', (model) =>
      @destroyTicket model, =>
        @app.navigate "/#{@meta.rootUrl}", { trigger:true }

    # done is executed when any of the previous actions finishes or is canceled
    @listenTo moduleChannel, 'done:tickets:ticket', =>
      @app.navigate "/#{@meta.rootUrl}", { trigger:true }



  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->
    @stopListening()



  # Module API
  # ------------------------

  ###
  List the categories
  ###
  list: -> moduleController.list()


  ###
  Edit some category

  @param {Integer} id      model id
  @param {Ticket}  model   category model
  ###
  edit: (id, model) -> moduleController.edit id, model


  ###
  Ticket deletion

  @param {Ticket}   model
  @param {Function} callback
  ###
  destroyTicket: (model, callback) ->
    model.destroy
      success: (model, response) =>
        flashMessage = i18n.t 'tickets:::Ticket successfully deleted'
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
