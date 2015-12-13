# Dependencies
# -----------------------

# Libs/generic stuff:
i18n = require 'i18next-client'

# Base class (extends Marionette.Module)
Module = require 'msq-appbase/lib/appBaseComponents/modules/Module'

# Module components:
Entities = require './entities'



###
Uploads module
==============

Currently this module just exposes some entities.
In the future this might change (with a file manager for the uploads or something)

@class
@augments BaseTmpModule

###
module.exports = class UploadsApp extends Module

  ###
  @property {Boolean} Autostart with the parent module (false by default)
  ###
  startWithParent: true


  ###
  Module initialization
  ###
  initialize: ->

    # register the module entities
    @app.module 'Entities.uploads', Entities
