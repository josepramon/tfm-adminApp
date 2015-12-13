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
Ticket model
==============

@class
@augments Model

###
module.exports = class Ticket extends Model

  ###
  @property {String} API url

  /api/tickets/tickets looks weird but it's consistent with the general API structure,
  the first /tickets/ is the module, and the second one is the entity

  ###
  urlRoot: '/api/tickets/tickets'


  ###
  @property {Object} Model default attributes
  ###
  defaults:

    ###
    @property {String} Ticket title
    ###
    title: ''

    ###
    @property {String} Ticket body
    ###
    body: ''

    ###
    @property {Array} Comments (from the user and the agents)
    ###
    comments: []

    ###
    @property {Array} Attached files
    ###
    attachments: []

    ###
    @property {Array} Ticket statuses (the current one and previous statuses)
    ###
    statuses: []

    ###
    @property {Array} Tags
    ###
    tags: []

    ###
    @property {Status} New ticket status
    ###
    status: null

    ###
    @property {Category} Category
    ###
    category: null

    ###
    @property {Number} Priority
    ###
    priority: 2

    ###
    @property {User} Ticket owner
    ###
    user: null

    ###
    @property {User} Assigned agent
    ###
    manager: null


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
      key:                  'manager'
      relatedModel:->       factory.invoke 'user:entities|User'
      saveFilterAttributes: ['id']
    ,
      type:                 Backbone.One
      key:                  'category'
      relatedModel:->       factory.invoke 'tickets:entities|Category'
      saveFilterAttributes: ['id']
    ,
      type:                 Backbone.Many
      key:                  'comments'
      collectionType:->     factory.invoke 'tickets:entities|CommentsCollection'
    ,
      type:                 Backbone.Many
      key:                  'statuses'
      collectionType:->     factory.invoke 'tickets:entities|TicketStatusesCollection'
      saveFilterAttributes: ['id']
    ,
      type:                 Backbone.One
      key:                  'status'
      relatedModel:->       factory.invoke 'tickets:entities|TicketStatus'
    ,
      type:                 Backbone.Many
      key:                  'attachments'
      collectionType:->     factory.invoke 'uploads:entities|AttachmentsCollection'
    ,
      type:                 Backbone.Many
      key:                  'tags'
      collectionType:->     factory.invoke 'tickets:entities|TagsCollection'
  ]


  ###
  @property {Object} Model validation rules
  ###
  validation:
    title:
      required: true
    body:
      required: true
    user:
      required: true
    category:
      required: true


  ###
  Relations to expand where querying the server

  @property {Array} the attributes to expand.
  @static
  ###
  @expandedRelations: [
    # retrieve everything to avoid multiple API calls
    'manager'
    'manager.profile'
    'manager.profile.image'
    'user'
    'user.profile'
    'user.profile.image'
    'category'
    'tags'
    'comments'
    'comments.user'
    'comments.user.profile'
    'comments.user.profile.image'
    'coments.attachments'
    'coments.attachments.upload'
    'statuses'
    'statuses.user'
    'statuses.user.profile'
    'statuses.user.profile.image'
    'statuses.status'
    'attachments'
    'attachments.upload'
  ]


  ###
  Timestamp fields

  js represents timestamps in miliseconds but the API represents that in seconds
  this fields will be automatically converted when fetching/saving

  @property {String[]} the attributes to transform
  ###
  timestampFields: ['created_at', 'updated_at']


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    id:            -> i18n.t 'tickets:::TicketModel::ID'
    title:         -> i18n.t 'tickets:::TicketModel::Title'
    body:          -> i18n.t 'tickets:::TicketModel::Body'
    comments:      -> i18n.t 'tickets:::TicketModel::Comments'
    attachments:   -> i18n.t 'tickets:::TicketModel::Attachments'
    statuses:      -> i18n.t 'tickets:::TicketModel::Statuses'
    category:      -> i18n.t 'tickets:::TicketModel::Category'
    priority:      -> i18n.t 'tickets:::TicketModel::Priority'
    user:          -> i18n.t 'tickets:::TicketModel::User'
    manager:       -> i18n.t 'tickets:::TicketModel::Manager'
    created_at:    -> i18n.t 'tickets:::TicketModel::Created_at'
    updated_at:    -> i18n.t 'tickets:::TicketModel::Updated_at'
    currentStatus: -> i18n.t 'tickets:::TicketModel::Status'
    tags:          -> i18n.t 'tickets:::TicketModel::Tags'
