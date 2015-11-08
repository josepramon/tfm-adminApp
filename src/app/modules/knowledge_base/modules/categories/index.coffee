# Dependencies
# -----------------------

# Libs/generic stuff:
_                = require 'underscore'
i18n             = require 'i18next-client'

# Base class (extends Marionette.Module)
Module           = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router           = require './ModuleRouter'
RouteController  = require './ModuleController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Posts module, and the parent
# module channel.
moduleChannel  = require './moduleChannel'
kbChannel      = require '../../moduleChannel'




###
Knowledge Base Categories module
=================================

Knowledge Base submodule responsible of Posts categories handling

@class
@augments Module

###
module.exports = class KBCategoriesApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t 'modules::KBCategories'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'knowledge-base/categories'

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
    @listenTo moduleChannel, 'create:kb:category', =>
      @create()
      @app.navigate "/#{@meta.rootUrl}/new"

    @listenTo moduleChannel, 'edit:kb:category', (model) =>
      @app.navigate "/#{@meta.rootUrl}/#{model.id}/edit"
      @edit model.id, model

    @listenTo moduleChannel, 'delete:kb:category', (model) =>
      @destroyCategory model, =>
        @app.navigate "/#{@meta.rootUrl}", { trigger:true }

    # done is executed when any of the previous actions finishes or is canceled
    @listenTo moduleChannel, 'done:kb:category', =>
      @app.navigate "/#{@meta.rootUrl}", { trigger:true }

    # display some category articles
    @listenTo moduleChannel, 'displayArticles:kb:category', (model) ->
      kbChannel.trigger 'categories:articles:list', model



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

  @param {Integer}  id      model id
  @param {Category} model   category model
  ###
  edit: (id, model) -> moduleController.edit id, model


  ###
  Create a new category
  ###
  create: -> moduleController.create()


  ###
  Category deletion

  @param {Category} model
  @param {Function} callback
  ###
  destroyCategory: (model, callback) ->
    model.destroy
      success: (model, response) =>
        flashMessage = i18n.t 'kb:::Category successfully deleted'
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
