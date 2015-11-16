# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
i18n  = require 'i18next-client'




###
UserLogin model
================

Used on the login view

@class
@augments Model

###
module.exports = class UserLogin extends Model

  # @property [String] API url
  url: '/api/auth'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {String} User name
    ###
    username : ''
    ###
    @property {String} User's password
    ###
    password : ''


  ###
  Timestamp fields

  js represents timestamps in miliseconds but the API represents that in seconds
  this fields will be automatically converted when fetching/saving

  @property {String[]} the attributes to transform
  ###
  timestampFields: ['created_at', 'updated_at', 'token_iat', 'token_exp']


  ###
  @property {Object} Model validation rules
  ###
  validation:
    username:
      required: true
    password:
      required: true


  ###
  Relations to expand where querying the server

  @property {Array} the attributes to expand
  @static
  ###
  @expandedRelations: ['user', 'user.profile']


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    username : -> i18n.t 'username'
    password : -> i18n.t 'password'


  ###
  Save error handler

  The API response for the login call is different from the other calls
  Make it compatible so there's no need to hack the view/controller
  ###
  saveError: (model, xhr, options) =>
    try
      response = $.parseJSON xhr.responseText
    catch error
      response = {}

    if response.error
      @set _errors:
        username: []
        password: [response.error?.message]

    super model, xhr, options
