# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# Other stuff
Model          = require 'msq-appbase/lib/appBaseComponents/entities/Model'
ListView       = require './list/ListView'
moduleChannel  = require './moduleChannel'




###
Module main controller
=======================

The class forwards the calls deffined in a module router to the appropiate
CRUD methods in the speciallised controllers (each controller is only responsible
for a task, like editing a record, or listing them).

@class
@augments ViewController

###
module.exports = class ModuleController extends ViewController

  #  Controller API:
  #  --------------------
  #
  #  Methods used by the router (and may be called directly from the module, too)

  # tmp: just show something until implemented...
  list: ->
    meta = moduleChannel.request 'meta'

    view = new ListView
      model: new Model
        moduleName: meta.title()
    @show view
