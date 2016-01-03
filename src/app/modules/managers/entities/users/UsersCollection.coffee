# Dependencies
# -------------------------

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# User model
User = require './User'


###
Users Collection
==============================

@class
@augments Collection

###
module.exports = class UsersCollection extends Collection
  model: User
  url: '/api/auth/users'
