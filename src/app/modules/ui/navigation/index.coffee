# Dependencies
# -----------------------

# Base class (extends Marionette.Module)
Module         = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
ListController = require './nav/ListController'



###
Navigation module
==================

@class
@augments Module

###
module.exports = class NavigationApp extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {Boolean} let the main app start/stop this whenever appropiate (for example on auth events)
    ###
    stopable: true


  # Module events
  # ------------------------

  # Event handler executed after the module has been initialized
  onStart: ->
    @lc = @getListController()


  # Event handler executed after the module has been stopped
  onStop: ->
    @lc.destroy()



  # Aux methods
  # -----------------

  ###
  ListController getter

  @return {ListController}
  ###
  getListController: =>
    new ListController
      region: @appChannel.request 'region', 'navRegion'
