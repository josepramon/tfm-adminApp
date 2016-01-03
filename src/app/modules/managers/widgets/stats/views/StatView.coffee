# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'




###
Users stats item view
===============================

@class
@augments ItemView

###
module.exports = class StatView extends ItemView
  template: require './templates/stat.hbs'
  className : 'stat'
