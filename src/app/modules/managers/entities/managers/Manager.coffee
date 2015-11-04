# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
_         = require 'underscore'
i18n      = require 'i18next-client'


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
