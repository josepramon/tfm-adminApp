# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Controller = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
ShowController = require './actions/show/ShowController'


###
Dashboard module main controller
=================================================

@class
@augments Controller

###
module.exports = class ModuleController extends Controller


  #  Controller API:
  #  --------------------
  #
  #  Methods used by the router (and may be called directly from the module, too)

  show: ->
    new ShowController()
