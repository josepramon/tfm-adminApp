# Dependencies
# -------------------------

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Article model
Article    = require './Article'




###
Article Collection
===================

@class
@augments Collection

###
module.exports = class ArticlesCollection extends Collection
  model: Article
  url: '/api/knowledge_base/articles'
