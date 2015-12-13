# Dependencies
# -------------------------

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Category model
Category   = require './Category'


###
Tickets Categories Collection
==============================

@class
@augments Collection

###
module.exports = class CategoriesCollection extends Collection
  model: Category
  url: '/api/tickets/categories'
