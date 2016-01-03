# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Controller = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
ShowController = require './actions/show/ShowController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the categories module, and the parent
# module channel.
moduleChannel  = require './moduleChannel'
ticketsChannel = require '../../moduleChannel'




###
Ticket stats module main controller
=================================================

The class forwards the calls deffined in a module router to the appropiate
CRUD methods in the speciallised controllers (each controller is only responsible
for a task, like editing a record, or listing them).

@class
@augments Controller

###
module.exports = class ModuleController extends Controller


  #  Controller API:
  #  --------------------
  #
  #  Methods used by the router (and may be called directly from the module, too)

  show: ->
    if @_hasPrivileges()
      new ShowController
        region: @getRegion 'main'


  ###
  Region getter

  @param  {String} region  The region name
  @return {Marionette.Region}
  ###
  getRegion: (region) ->
    layout = ticketsChannel.request 'layout:get'
    layout.getRegion region


  ###
  Access control
  ###
  _hasPrivileges: ->
    permissions = {tickets: {actions: {stats: true}}}
    @appChannel.request 'auth:requireAuth', permissions, false
