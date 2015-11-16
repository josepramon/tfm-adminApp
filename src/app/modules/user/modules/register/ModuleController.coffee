# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Controller = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
RegisterController = require './actions/register/RegisterController'




###
Register module main controller
================================

The class forwards the calls deffined in a module router to the appropiate
CRUD methods in the speciallised controllers (each controller is only responsible
for a task, like editing a record, or listing them).

@class
@augments Controller

###
module.exports = class ModuleController extends Controller

  #  Controller API:
  #  --------------------

  register: ->
    new RegisterController()
