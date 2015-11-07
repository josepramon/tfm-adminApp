# Dependencies
# -----------------------

# Libs/generic stuff:
i18n               = require 'i18next-client'

# Base class
KBCategoryEditView = require '../../edit/views/EditView'




###
Category create view
=====================

Basically identical to the 'edit' view, but with different buttons

@class
@augments KBCategoryEditView

###
module.exports = class KBCategoryCreateView extends KBCategoryEditView

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
