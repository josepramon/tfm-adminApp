# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Base class (extends Marionette.Module)
Module            = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
LayoutController  = require './layout/LayoutController'
Router            = require './ModuleRouter'
RouteController   = require './ModuleController'
SessionController = require './SessionController'
Entities          = require './entities'
moduleChannel     = require './moduleChannel'




###
User module
=============

Module responsible for auth and session handling

@class
@augments Module

###
module.exports = class UserApp extends Module

  ###
  @property {Boolean} Autostart with the parent module (false by default)
  ###
  startWithParent: true

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t('modules::User')

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'user'


  ###
  Module initialization

  @param {Object} options
  ###
  initialize: (options) ->

    # register the module entities
    @app.module 'Entities', Entities

    # setup the module router
    @setupRouter()
    @appChannel.reply 'auth:routes:login',  => @meta.rootUrl + '/login'
    @appChannel.reply 'auth:routes:error',  => @meta.rootUrl + '/authError'

    @listenTo moduleChannel, 'redirect:login', ->
      Backbone.history.navigate @meta.rootUrl + '/login', { trigger: true }

    # initialize the session
    sessionController = new SessionController()

    # initialize the shared layout
    @initModuleLayout()

    # module metadata getter
    moduleChannel.reply 'meta', => @meta


  ###
  Module router initialization
  ###
  setupRouter: ->
    moduleRouter = new Router
      controller: new RouteController()
      rootUrl:    @meta.rootUrl


  # Aux methods
  # ------------------------

  ###
  Initialize the module layout
  ###
  initModuleLayout: ->
    layout = new LayoutController()
