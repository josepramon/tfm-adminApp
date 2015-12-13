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
Comment model
==============

@class
@augments Model

###
module.exports = class Comment extends Model

  ###
  @property {Object} Model default attributes
  ###
  defaults:

    ###
    @property {String} Comment content
    ###
    comment: ''

    ###
    @property {User} Comment author
    ###
    user: null

    ###
    @property {Array} Attached files
    ###
    attachments: []

    ###
    @property {Array} Comment visibility
    ###
    private: false


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:                 Backbone.One
      key:                  'user'
      relatedModel:->       factory.invoke 'user:entities|User'
      saveFilterAttributes: ['id']
    ,
      type:                 Backbone.Many
      key:                  'attachments'
      collectionType:->     factory.invoke 'uploads:entities|AttachmentsCollection'
  ]


  ###
  Relations to expand where querying the server

  @property {Array} the attributes to expand.
  @static
  ###
  @expandedRelations: [
    'user'
    'user.profile'
    'user.profile.image'
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
  @property {Object} Model validation rules
  ###
  validation:
    comment:
      required: true
    user:
      required: true


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    comment:     -> i18n.t 'tickets:::CommentModel::Comment'
    user:        -> i18n.t 'tickets:::CommentModel::User'
    attachments: -> i18n.t 'tickets:::CommentModel::Attachments'
    created_at:  -> i18n.t 'tickets:::CommentModel::Created_at'
    updated_at:  -> i18n.t 'tickets:::CommentModel::Updated_at'
