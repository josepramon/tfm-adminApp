# Dependencies
# -----------------------

# Base class (extends Marionette.Module)
Module          = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
ListController  = require './nav/ListController'


###
Footer module
==================

@class
@augments Module

###
module.exports = class FooterApp extends Module

  ###
  @property {Boolean} Autostart with the parent module (false by default)
  ###
  startWithParent: true


  # Module events
  # ------------------------

  ###
  Event handler executed after the module has been initialized
  ###
  onStart: ->
    controller = @getListController()


  # Aux methods
  # -----------------

  ###
  ListController getter

  @return {ListController}
  ###
  getListController: =>
    new ListController
      region: @appChannel.request 'region', 'footerRegion'
