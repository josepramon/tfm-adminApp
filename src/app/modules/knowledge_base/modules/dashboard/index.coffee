# Dependencies
# -----------------------

# Libs/generic stuff:
i18n = require 'i18next-client'

# Libs/generic stuff:
Backbone         = require 'backbone'

# Base class (extends Marionette.Module)
Module          = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router          = require './ModuleRouter'
RouteController = require './ModuleController'

# Widgets
StatsWidget    = require './widgets/stats'
TagCloudWidget = require './widgets/tagcloud'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Dashboard module, and the parent
# module (knowledge base) channel.
kbChannel   = require '../../moduleChannel'
moduleChannel = require './moduleChannel'


###
Knowledge Base Dashboard module
================================

Dashboard submodule responsible for the Knowledge Base dashboard

@class
@augments Module

###
module.exports = class KBDashboardApp extends Module

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
    showInModuleNavigation: false

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

    # widget getters:
    # expose the widgets on the global channel so they can be used anywhere
    @appChannel.reply 'widgets:kb:stats',    (opts) -> new StatsWidget opts
    @appChannel.reply 'widgets:kb:tagCloud', (opts) -> new TagCloudWidget opts



  # Aux methods
  # ------------------------

  ###
  Setup the module router
  ###
  initModuleRouter: ->
    moduleRouter = new Router
      controller: new RouteController()
      rootUrl:    @meta.rootUrl
