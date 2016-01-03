# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
_         = require 'underscore'
i18n      = require 'i18next-client'
factory   = require 'msq-appbase/lib/utilities/factory'
Backbone  = require 'backbone'


###
Manager model
==============

@class
@augments Model

###
module.exports = class Manager extends Model

  ###
  @property {String} API url
  ###
  urlRoot: '/api/auth/managers'


  ###
  @property {Object} Model default attributes
  ###
  defaults:

    ###
    @property {String} Username
    ###
    username: null

    ###
    @property {String} Email
    ###
    email: null

    ###
    @property {Profile} Profile model
    ###
    profile: null


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:           Backbone.One
      key:            'profile'
      relatedModel:-> factory.invoke 'user:entities|Profile'
  ]


  ###
  Relations to expand where querying the server

  @property {Array} the attributes to expand.
  @static
  ###
  @expandedRelations: ['profile', 'profile.image']


  ###
  Timestamp fields

  js represents timestamps in miliseconds but the API represents that in seconds
  this fields will be automatically converted when fetching/saving

  @property {String[]} the attributes to transform
  ###
  timestampFields: ['created_at', 'updated_at']


  ###
  @property {Object} Model validation rules
  ###
  validation:
    username:
      required: true
    email:
      required: true
      pattern: 'email'



  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    username : -> i18n.t 'managers:::ManagerModel::username'
    email    : -> i18n.t 'managers:::ManagerModel::email'
