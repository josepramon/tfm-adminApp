# Dependencies
# -------------------------

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Comment model
Comment = require './Comment'


###
Comments Collection
====================

@class
@augments Collection

###
module.exports = class CommentsCollection extends Collection
  model: Comment

