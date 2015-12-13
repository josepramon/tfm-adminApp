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
Tag model
==============

@class
@augments Model

###
module.exports = class Tag extends Model

  ###
  @property {String} API url
  ###
  urlRoot: '/api/tickets/tags'


  ###
  @property {Object} Model default attributes
  ###
  defaults:

    ###
    @property {String} Tag name
    ###
    name: ''

    ###
    @property {String} Tag description
    ###
    description: ''


  ###
  @property {Object} Model validation rules
  ###
  validation:
    name:
      required: true


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    name          : -> i18n.t 'tickets:::TagModel::Name'
    description   : -> i18n.t 'tickets:::TagModel::Description'
    tickets       : -> i18n.t 'tickets:::TagModel::Tickets'
    tickets_total : -> i18n.t 'tickets:::TagModel::Tickets_total'
