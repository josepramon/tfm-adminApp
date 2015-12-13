# Dependencies
# -----------------------

# Libs/generic stuff:
i18n           = require 'i18next-client'

# Base class
KBPostEditView = require '../../edit/views/EditView'




###
Tag create view
=================

Basically identical to the 'edit' view, but with different buttons

@class
@augments KBPostEditView

###
module.exports = class TagCreateView extends KBPostEditView

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
