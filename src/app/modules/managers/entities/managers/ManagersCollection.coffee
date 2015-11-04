# Dependencies
# -------------------------

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Manager model
Manager = require './Manager'




###
Managers Collection
===================

@class
@augments Collection

###
module.exports = class ManagersCollection extends Collection
  model: Manager
  url: '/api/auth/managers'
