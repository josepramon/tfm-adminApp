# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Module         = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components
ListController = require './list/ListController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there's an addittional independent channel, the
# channel for the parent  module (Header) channel.
headerChannel  = require '../../moduleChannel'




###
Language switcher module
=========================

@class
@augments ModuleController

###
module.exports = class LanguageSwitcher extends Module

  ###
  Module initialization
  ###
  initialize: ->
    # start/stop AFTER the parent module
    @listenTo headerChannel, 'header:started', => @start()
    @listenTo headerChannel, 'header:stopped', => @stop()


  ###
  Event handler executed after the module has been initialized
  ###
  onStart: ->
    @lc = new ListController
      region: headerChannel.request 'region', 'languageSwitcher'


  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->
    @lc.destroy()
