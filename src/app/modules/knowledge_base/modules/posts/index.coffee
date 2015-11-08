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
LayoutController = require './layout/LayoutController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Posts module, and the parent
# module channel.
moduleChannel = require './moduleChannel'
kbChannel     = require '../../moduleChannel'




###
Knowledge Base Posts module
============================

Knowledge Base submodule responsible of Posts handling

@class
@augments Module

###
module.exports = class KBPostsApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t 'modules::KBPosts'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'knowledge-base/posts'

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
    @initModuleLayout()
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
    @listenTo moduleChannel, 'create:kb:post', =>
      @create()
      @app.navigate "/#{@meta.rootUrl}/new"

    @listenTo moduleChannel, 'edit:kb:post', (model) =>
      @app.navigate "/#{@meta.rootUrl}/#{model.id}/edit"
      @edit model.id, model

    @listenTo moduleChannel, 'delete:kb:post', (model) =>
      @destroyArticle model, ->
        moduleChannel.trigger 'deleted:kb:post', model

    # done is executed when any of the previous actions finishes or is canceled
    @listenTo moduleChannel, 'done:kb:post', =>
      @app.navigate "/#{@meta.rootUrl}"

    # the media list should be always visible on this module
    # so init it whenever the layout is initialized
    @listenTo moduleChannel, 'layout:rendered', (data) =>
      @list()

    # additional handlers for the tags/categories modules
    @listenTo kbChannel, 'categories:articles:list', (category) =>
      @app.navigate "/#{@meta.rootUrl}/byCategory/#{category.id}"
      @listByCategory category.id, category

    @listenTo kbChannel, 'tags:articles:list', (tag) =>
      @app.navigate "/#{@meta.rootUrl}/byTag/#{tag.id}"
      @listByTag tag.id, tag


  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->
    @stopListening()



  # Module API
  # ------------------------

  ###
  List the articles
  ###
  list: -> moduleController.list()


  ###
  List the articles for some category

  @param {Integer} id      model id
  @param {Category} model  category model
  ###
  listByCategory: (id, model) -> moduleController.listCategoryArticles id, model


  ###
  List the articles for some tag

  @param {Integer} id  model id
  @param {Tag} model   tag model
  ###
  listByTag: (id, model) -> moduleController.listTagArticles id, model


  ###
  Edit some article

  @param {Integer} id      model id
  @param {Article} model   article model
  ###
  edit: (id, model) -> moduleController.edit id, model


  ###
  Create a new article
  ###
  create:  -> moduleController.create()


  ###
  Article deletion

  @param {Article} model
  @param {Function} callback
  ###
  destroyArticle: (model, callback) ->
    model.destroy
      success: (model, response) =>
        flashMessage = i18n.t 'kb:::Article successfully deleted'
        @appChannel.request 'flash:success', flashMessage
        if _.isFunction callback then callback(model, response)



  # Aux methods
  # ------------------------

  ###
  Initialize the module layout
  ###
  initModuleLayout: ->
    layout = new LayoutController()


  ###
  Setup the module router
  ###
  initModuleRouter: ->
    moduleController = new RouteController()

    moduleRouter = new Router
      controller: moduleController
      rootUrl:    @meta.rootUrl
