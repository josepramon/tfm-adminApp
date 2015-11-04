# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
i18n  = require 'i18next-client'




###
Register model
================

@class
@augments Model

###
module.exports = class Register extends Model

  # @property [String] API url
  url: '/api/auth/users'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {String} User name
    ###
    username : ''
    ###
    @property {String} User's email
    ###
    email : ''
    ###
    @property {String} User's password
    ###
    password : ''


  ###
  @property {Object} Model validation rules
  ###
  validation:
    username:
      required: true
    email:
      pattern: 'email'
      required: true
    password:
      required: true
    rePassword:
      required: true
      equalTo: 'password'


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    username:    -> i18n.t 'UserModel::username'
    password:    -> i18n.t 'UserModel::password'
    rePassword:  -> i18n.t 'UserModel::rePassword'
    email:       -> i18n.t 'UserModel::email'
