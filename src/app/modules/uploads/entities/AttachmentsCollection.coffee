# Dependencies
# -------------------------

_          = require 'underscore'

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Attachment model
Attachment = require './Attachment'


###
Attachments Collection
==============================

@class
@augments Collection

###
module.exports = class AttachmentsCollection extends Collection
  model: Attachment
