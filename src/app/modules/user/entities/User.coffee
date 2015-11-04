# Dependencies
# -------------------------

# Libs/generic stuff:
$         = require 'jquery'
_         = require 'underscore'
Backbone  = require 'backbone'
i18n      = require 'i18next-client'

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Related models
ProfileModel = require './Profile'

# Utility to compare privileges
checkPrivileges = require './util/PrivilegesChecker'



###
User model
==============

@class
@augments Model

###
module.exports = class User extends Model

  ###
  @property {String} API url
  ###
  urlRoot: ->
    base = '/api/auth/'
    role = @get 'role'

    if role
      base + role.toLowerCase() + 's'
    else
      base + 'users'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    id:         null
    username:   ''
    email:      ''
    role:       ''
    privileges: null
    profile:    null


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:         Backbone.One
      key:          'profile'
      relatedModel: ProfileModel
  ]


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
    password:
      required: (value, attr, computedState) ->
        !!computedState.rePassword || !!computedState.oldPassword
    oldPassword:
      required: (value, attr, computedState) ->
        !!computedState.password
    rePassword:
      equalTo: 'password'
      required: (value, attr, computedState) ->
        !!computedState.password


  ###
  Privileges verification
  ###
  hasAccess: (requiredPermissions) ->
    return checkPrivileges(requiredPermissions, @get 'privileges')


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    username:    -> i18n.t 'UserModel::username'
    password:    -> i18n.t 'UserModel::password'
    rePassword:  -> i18n.t 'UserModel::rePassword'
    oldPassword: -> i18n.t 'UserModel::oldPassword'
    email:       -> i18n.t 'UserModel::email'
    role:        -> i18n.t 'UserModel::role'
    privileges:  -> i18n.t 'UserModel::privileges'
    profile:     -> i18n.t 'UserModel::profile'
