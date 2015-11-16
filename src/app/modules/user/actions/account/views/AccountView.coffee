# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'



###
Account edit view
=======================

@class
@augments ItemView

###
module.exports = class AccountView extends ItemView
  template: require './templates/account.hbs'

  ###
  @property {Object} form config.
  ###
  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Save'
          icon: 'check'
