# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Module         = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components
NavController  = require './nav/NavController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there's an addittional independent channel, the
# channel for the parent  module (Header) channel.
headerChannel  = require '../../moduleChannel'




###
Header navigation module
=========================

@class
@augments ModuleController

###
module.exports = class HeaderNav extends Module

  ###
  @property {Object} module metadata, used to setup the navigation and for other purposes
  ###
  meta:
    ###
    @property {Boolean} let the main app start/stop this whenever appropiate (for example on auth events)
    ###
    stopable: true


  ###
  Event handler executed after the module has been initialized
  ###
  onStart: ->
    @nc = new NavController
      region: headerChannel.request 'region', 'headerNav'


  ###
  Event handler executed after the module has been stopped
  ###
  onStop: ->
    @nc.destroy()
