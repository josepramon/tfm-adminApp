# Dependencies
# -----------------------

# Base class (extends Marionette.Module)
Module            = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router            = require './ModuleRouter'
RouteController   = require './ModuleController'
SessionController = require './SessionController'
Entities          = require './entities'




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
    title: 'modules::User'

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

    # initialize the session
    sessionController = new SessionController()


  ###
  Module router initialization
  ###
  setupRouter: ->
    moduleRouter = new Router
      controller: new RouteController()
      rootUrl:    @meta.rootUrl
