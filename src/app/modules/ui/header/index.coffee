# Dependencies
# -----------------------

# Base class (extends Marionette.Module)
Module           = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
LayoutController = require './layout/LayoutController'
headerChannel    = require './moduleChannel'


###
Header module
==================

@class
@augments Module

###
module.exports = class HeaderApp extends Module

  ###
  @property {Boolean} Autostart with the parent module (false by default)
  ###
  startWithParent: true


  # Module events
  # ------------------------

  ###
  Event handler executed after the module has been started
  ###
  onStart: ->
    @initLayout()

    # This module has some widgets (submodules), like the language switcher.
    # Some of this modules should be started AFTER this module layout is available.
    # Other modules will start/stop on other application events.
    headerChannel.trigger 'header:started'


  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->
    @destroyLayout()
    headerChannel.trigger 'header:stopped'



  # Aux methods
  # ------------------------

  ###
  Creates the module layout controller

  The controller is responsible of the layout rendering and manages
  its regions (the containers for this module widgets)
  ###
  initLayout: ->
    @layoutController = new LayoutController
      region: @appChannel.request 'region', 'headerRegion'


  ###
  Layout controller destruction
  ###
  destroyLayout: ->
    @layoutController.destroy()
