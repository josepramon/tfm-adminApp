
# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
i18n      = require 'i18next-client'
factory   = require 'msq-appbase/lib/utilities/factory'
Backbone  = require 'backbone'


###
Ticket status model
=======================

@class
@augments Model

###
module.exports = class TicketStatus extends Model

  ###
  @property {Object} Model default attributes
  ###
  defaults:
    status: null
    user: null
    comments: ''


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:                 Backbone.One
      key:                  'user'
      relatedModel:->       factory.invoke 'user:entities|User'
      saveFilterAttributes: ['id']
    ,
      type:                 Backbone.One
      key:                  'status'
      relatedModel:->       factory.invoke 'tickets:entities|Status'
      saveFilterAttributes: ['id']
  ]


  ###
  Relations to expand where querying the server

  @property {Array} the attributes to expand.
  @static
  ###
  @expandedRelations: [
    'status'
    'user'
    'user.profile'
    'user.profile.image'
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
    status:
      required: true
    user:
      required: true
    comments:
      # comments are required only when closing or reopening the ticket
      required: (value, attr, computedState) ->
        model = computedState.status
        if !model then return true
        model.get('open') or model.get('closed')



  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    comments: -> i18n.t 'tickets:::TicketStatusModel::Comments'
    status:   -> i18n.t 'tickets:::TicketStatusModel::Status'
