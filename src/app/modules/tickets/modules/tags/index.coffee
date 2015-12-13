# Dependencies
# -----------------------

# Libs/generic stuff:
_        = require 'underscore'
i18n     = require 'i18next-client'

# Base class (extends Marionette.Module)
Module   = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router          = require './ModuleRouter'
RouteController = require './ModuleController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Tags module, and the parent
# module channel.
kbChannel     = require '../../moduleChannel'
moduleChannel = require './moduleChannel'


###
Knowledge Base Tags module
===========================

Knowledge Base submodule responsible of Tags handling

@class
@augments Module

###
module.exports = class KBTagsApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t 'modules::KBTags'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'knowledge-base/tags'

    ###
    @property {String} icon (font awesome class) that identifies the module
    ###
    icon: 'newspaper-o'

    ###
    @property {Boolean} show the module in the app navigation
    ###
    showInModuleNavigation: false

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
    @listenTo moduleChannel, 'create:kb:tag', =>
      @create()
      @app.navigate "/#{@meta.rootUrl}/new"

    @listenTo moduleChannel, 'edit:kb:tag', (model) =>
      @app.navigate "/#{@meta.rootUrl}/#{model.id}/edit"
      @edit model.id, model

    @listenTo moduleChannel, 'delete:kb:tag', (model) =>
      @destroyTag model, =>
        @app.navigate "/#{@meta.rootUrl}", { trigger:true }

    # done is executed when any of the previous actions finishes or is canceled
    @listenTo moduleChannel, 'done:kb:tag', =>
      @app.navigate "/#{@meta.rootUrl}", { trigger:true }

    @listenTo moduleChannel, 'displayArticles:kb:tag', (model) ->
      kbChannel.trigger 'tags:articles:list', model



  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->
    @stopListening()


  # Module API
  # ------------------------

  ###
  List the tags
  ###
  list: -> moduleController.list()


  ###
  Edit some tag

  @param {Integer} id      model id
  @param {Tag}     model   tag model
  ###
  edit: (id, model) -> moduleController.edit id, model


  ###
  Create a new tag
  ###
  create: -> moduleController.create()


  ###
  Tag deletion

  @param {Tag} model
  @param {Function} callback
  ###
  destroyTag: (model, callback) ->
    model.destroy
      success: (model, response) =>
        flashMessage = i18n.t 'kb:::Tag successfully deleted'
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
