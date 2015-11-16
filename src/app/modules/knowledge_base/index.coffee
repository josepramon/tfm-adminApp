# Dependencies
# -----------------------

# Libs/generic stuff:
i18n = require 'i18next-client'

# Base class (extends Marionette.Module)
Module = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
LayoutController = require './layout/LayoutController'
Entities         = require './entities'
moduleChannel    = require './moduleChannel'




###
Knowledge Base module
=====================

@class
@augments Module

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

    # register the module entities
    @app.module 'Entities.kb', Entities

    # setup the module components
    @initModuleLayout()

    # module metadata getter
    moduleChannel.reply 'meta', => @meta



  # Aux methods
  # ------------------------

  ###
  Initialize the module layout
  ###
  initModuleLayout: ->
    layout = new LayoutController()
