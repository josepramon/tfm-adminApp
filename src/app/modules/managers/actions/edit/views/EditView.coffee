# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'




###
Manager edit view
=======================

@class
@augments ItemView

###
module.exports = class ManagerEditView extends ItemView
  template: require './templates/edit.hbs'
  className: 'sectionContainer'


  ###
  @property {Object} form config.
  ###
  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Save'
          icon: 'check'
        cancel:
          text: -> i18n.t 'Cancel'
      secondaryActions:
        delete:
          type:      'delete'
          className: 'btn btn-danger'
          text:      -> i18n.t 'Delete'
          icon:      'trash'
