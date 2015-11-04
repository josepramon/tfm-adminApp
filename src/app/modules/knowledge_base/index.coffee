# Dependencies
# -----------------------

# Libs/generic stuff:
i18n = require 'i18next-client'

# Base class (extends Marionette.Module)
Module          = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router          = require './ModuleRouter'
RouteController = require './ModuleController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there's an addittional independent channel specific to
# the module
moduleChannel = require './moduleChannel'



###
Knowledge Base module
=====================

@class
@augments BaseTmpModule

###
module.exports = class KnowledgeBaseApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: -> i18n.t 'modules::KnowledgeBase'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: 'knowledge-base'

    ###
    @property {String} icon (font awesome class) that identifies the module
    ###
    icon: 'book'

    ###
    @property {Boolean} show the module in the app navigation
    ###
    showInModuleNavigation: true

    ###
    @property {String} locale namespace needed by this module (will be autoloaded)
    ###
    localeNS : 'kb'

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

    # module metadata getter
    moduleChannel.reply 'meta', => @meta



  # Module events
  # ------------------------

  ###
  Event handler executed after the module has been started
  ###
  onStart: ->


  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->



  # Aux methods
  # ------------------------

  ###
  Setup the module router
  ###
  initModuleRouter: ->
    moduleRouter = new Router
      controller: new RouteController()
      rootUrl:    @meta.rootUrl
