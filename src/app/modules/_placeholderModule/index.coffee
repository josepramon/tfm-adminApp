# Dependencies
# -----------------------

# Base class (extends Marionette.Module)
Module           = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Router           = require './ModuleRouter'
RouteController  = require './ModuleController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# this module has an addittional independent channel.
moduleChannel    = require './moduleChannel'




###
Placeholder module
===================

Base module for unimplemented ones

@class
@augments Module

###
module.exports = class PlaceholderModuleApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {String} human readable module name
    ###
    title: 'PlaceholderModule'

    ###
    @property {String} root url for all module routes
    ###
    rootUrl: ''

    ###
    @property {String} icon (font awesome class) that identifies the module
    ###
    icon: ''

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

    moduleRouter = new Router
      controller: new RouteController()
      rootUrl:    @meta.rootUrl

    # module metadata getter
    moduleChannel.reply 'meta', => @meta



  # Module events
  # ------------------------

  ###
  Event handler executed after the module has been initialized
  ###
  onStart: ->
    console.log 'Module ' + @meta.title() + ' started'
