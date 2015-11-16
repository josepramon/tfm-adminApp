# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
i18n  = require 'i18next-client'




###
Password recovery model
=======================

@class
@augments Model

###
module.exports = class PasswordRecovery extends Model

  # @property [String] API url
  url: '/api/auth/recover'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {String} User's email
    ###
    email : ''


  ###
  @property {Object} Model validation rules
  ###
  validation:
    email:
      pattern: 'email'
      required: true



  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    email: -> i18n.t 'UserModel::email'
