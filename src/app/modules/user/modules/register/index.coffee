# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Base class (extends Marionette.Module)
Module            = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router            = require './ModuleRouter'
RouteController   = require './ModuleController'




###
Register submodule
====================

Implemented as a module instead of an action so it can be disabled

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
    title: -> i18n.t('modules::Register')

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'user'


  ###
  Module initialization

  @param {Object} options
  ###
  initialize: (options) ->

    # setup the module router
    @setupRouter()


  ###
  Module router initialization
  ###
  setupRouter: ->
    moduleRouter = new Router
      controller: new RouteController()
      rootUrl:    @meta.rootUrl
