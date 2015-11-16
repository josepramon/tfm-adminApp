# Dependencies
# -------------------------

i18n = require 'i18next-client'

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'



###
User profile model
===================

@class
@augments Model

###
module.exports = class Profile extends Model

  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    name:     -> i18n.t 'UserProfileModel::name'
    surname:  -> i18n.t 'UserProfileModel::surname'
    phone:    -> i18n.t 'UserProfileModel::phone'
    location: -> i18n.t 'UserProfileModel::location'
    company:  -> i18n.t 'UserProfileModel::company'
    url:      -> i18n.t 'UserProfileModel::url'
