# Dependencies
# -------------------------

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Tag model
Tag        = require './Tag'


###
Tags Collection
===================

@class
@augments Collection

###
module.exports = class TagsCollection extends Collection
  model: Tag
  url: '/api/knowledge_base/tags'
