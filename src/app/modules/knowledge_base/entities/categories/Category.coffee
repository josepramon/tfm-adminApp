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
Article category model
=======================

@class
@augments Model

###
module.exports = class Category extends Model

  ###
  @property {String} API url
  ###
  urlRoot: '/api/knowledge_base/categories'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {ArticlesCollection} Articles tagged with this model
    ###
    articles: []

    ###
    @property {String} Category name
    ###
    name: ''

    ###
    @property {String} Category description
    ###
    description: ''

    ###
    @property {String} Slug (used on the URL)
    ###
    slug: null

    ###
    @property {Number} Determines the ordering
    ###
    weight: null



  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:           Backbone.Many
      key:            'articles'
      collectionType: -> factory.invoke 'kb:entities|ArticlesCollection'
  ]


  ###
  @property {Object} Virtual fields
  ###
  computed:
    articles_total:
      get: ->
        articles = @get 'articles'
        total    = if articles and articles.state then articles.state.totalRecords
        unless total then total = 0
        total
      transient: true


  ###
  @property {Object} Model validation rules
  ###
  validation:
    name:
      required: true
    weight:
      pattern: 'number'
      required: false


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    name            : -> i18n.t 'kb:::CategoryModel::name'
    description     : -> i18n.t 'kb:::CategoryModel::description'
    slug            : -> i18n.t 'kb:::CategoryModel::slug'
    articles        : -> i18n.t 'kb:::CategoryModel::articles'
    articles_total  : -> i18n.t 'kb:::CategoryModel::articles'
    weight          : -> i18n.t 'kb:::CategoryModel::weight'
