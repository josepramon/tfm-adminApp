# Dependencies
# -----------------------

# Libs/generic stuff:
i18n = require 'i18next-client'

# Base class (extends Marionette.Module)
Module = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router          = require './ModuleRouter'
RouteController = require './ModuleController'


###
Dashboard module
==================

@class
@augments BaseTmpModule

###
module.exports = class DashboardApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t 'modules::Dashboard'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: ''

    ###
    @property {Boolean} let the main app start/stop this whenever appropiate (for example on auth events)
    ###
    stopable: true


  ###
  Module initialization
  ###
  initialize: ->
    # setup the module components
    @initModuleRouter()


  # Aux methods
  # ------------------------

  ###
  Setup the module router
  ###
  initModuleRouter: ->
    moduleRouter = new Router
      controller: new RouteController()
      rootUrl:    @meta.rootUrl
