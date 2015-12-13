# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
i18n      = require 'i18next-client'
factory   = require 'msq-appbase/lib/utilities/factory'
Backbone  = require 'backbone'


###
Ticket category model
=======================

@class
@augments Model

###
module.exports = class Category extends Model

  ###
  @property {String} API url
  ###
  urlRoot: '/api/tickets/categories'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {ManagersCollection} Managers assigned to this category
    ###
    managers: []

    ###
    @property {String} Category name
    ###
    name: ''

    ###
    @property {String} Category description
    ###
    description: ''


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:           Backbone.Many
      key:            'managers'
      collectionType: -> factory.invoke 'users:entities|ManagersCollection'
      saveFilterAttributes: ['id']
  ]


  ###
  Relations to expand where querying the server

  @property {Array} the attributes to expand.
  @static
  ###
  @expandedRelations: ['managers']


  ###
  @property {Object} Virtual fields
  ###
  computed:
    managers_total:
      get: ->
        managers = @get 'managers'
        total    = if managers and managers.state then managers.state.totalRecords
        unless total then total = 0
        total
      transient: true


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
    name            : -> i18n.t 'tickets:::CategoryModel::name'
    description     : -> i18n.t 'tickets:::CategoryModel::description'
    managers        : -> i18n.t 'tickets:::CategoryModel::managers'
    managers_total  : -> i18n.t 'tickets:::CategoryModel::managers'
