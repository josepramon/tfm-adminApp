# Dependencies
# -----------------------

_       = require 'underscore'
channel = require 'msq-appbase/lib/utilities/appChannel'

# Base class
ModuleEntities = require 'msq-appbase/lib/appBaseComponents/modules/ModuleEntities'

# Entities
Article              = require './articles/Article'
ArticlesCollection   = require './articles/ArticlesCollection'

Tag                  = require './tags/Tag'
TagsCollection       = require './tags/TagsCollection'

Category             = require './categories/Category'
CategoriesCollection = require './categories/CategoriesCollection'


###
Knowledge base entities submodule
===================================

Handles the instantiation of the entities exposed by this module.

###
module.exports = class KBEntities extends ModuleEntities

  ###
  @property {String} Factory id

  When dealing with relations, in some circumstances there may be circular
  references between the related models, and this is very problematic with
  browserify/node require method.

  So, instead, there's a global application factory object that handles the
  instantiation of entities avoiding direct references.

  The 'global' factory methods are namespaced to make it scalable.
  So, for example, in 'kb:entities|TagsCollection', 'kb:entities' is th NS.
  ###
  factoryId: 'kb:entities'


  ###
  @property {Object} Maps the identifiers to the classes
  ###
  factoryClassMap:
    'Article'                   : Article
    'ArticlesCollection'        : ArticlesCollection

    'Tag'                       : Tag
    'TagsCollection'            : TagsCollection

    'Category'                  : Category
    'CategoriesCollection'      : CategoriesCollection



  ###
  Usually, when an entity is needed, it needs to be initialized with some defaults
  or with some state. This methods centralize this functionality here instead of
  disseminating it across multiple controllers and other files.
  ###
  handlers: =>
    # -------- Articles --------
    'kb:articles:entities':     @_initializeArticlesCollection
    'kb:articles:entity':       @_initializeArticleModel
    'new:kb:articles:entity':   @_initializeEmptyArticleModel

    # -------- Tags --------
    'kb:tags:entities':         @_initializeTagsCollection
    'kb:tags:entity':           @_initializeTagModel
    'new:kb:tags:entity':       @_initializeEmptyTagModel

    # -------- Categories --------
    'kb:categories:entities':   @_initializeCategoriesCollection
    'kb:categories:entity':     @_initializeCategoryModel
    'new:kb:categories:entity': @_initializeEmptyCategoryModel



  # Aux methods
  # ------------------------

  # handlers for the article related entities:

  _initializeArticlesCollection: (options) =>
    @initializeCollection 'kb:entities|ArticlesCollection', options

  _initializeArticleModel: (id, options) =>
    @initializeModel 'kb:entities|Article', id, options

  _initializeEmptyArticleModel: =>
    @initializeEmptyModel 'kb:entities|Article'


  # handlers for the tag related entities:

  _initializeTagsCollection: (options) =>
    @initializeCollection 'kb:entities|TagsCollection', options

  _initializeTagModel: (id, options) =>
    @initializeModel 'kb:entities|Tag', id, options

  _initializeEmptyTagModel: =>
    @initializeEmptyModel 'kb:entities|Tag'


  # handlers for the categories related entities:

  _initializeCategoriesCollection: (options) =>
    @initializeCollection 'kb:entities|CategoriesCollection', options

  _initializeCategoryModel: (id, options) =>
    @initializeModel 'kb:entities|Category', id, options

  _initializeEmptyCategoryModel: =>
    @initializeEmptyModel 'kb:entities|Category'
