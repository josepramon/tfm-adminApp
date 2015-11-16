# Dependencies
# -----------------------

# Libs/generic stuff:
i18n            = require 'i18next-client'

# Base class
ManagerEditView = require '../../edit/views/EditView'




###
Manager create view
=====================

Basically identical to the 'edit' view, but with different buttons

@class
@augments ManagerEditView

###
module.exports = class ManagerCreateView extends ManagerEditView

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
