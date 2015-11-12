# Dependencies
# -----------------------

_          = require 'underscore'
StringUtil = require 'msq-appbase/lib/utilities/string'

# Base class (extends Marionette.Controller)
Controller = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
ListController   = require './actions/list/ListController'
EditController   = require './actions/edit/EditController'
CreateController = require './actions/create/CreateController'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Posts module, and the parent
# module channel.
moduleChannel = require './moduleChannel'
kbChannel     = require '../../moduleChannel'




###
Knowledge Base posts module main controller
============================================

The class forwards the calls deffined in a module router to the appropiate
CRUD methods in the speciallised controllers (each controller is only responsible
for a task, like editing a record, or listing them).

@class
@augments Controller

###
module.exports = class ModuleController extends Controller


  #  Controller API:
  #  --------------------
  #
  #  Methods used by the router (and may be called directly from the module, too)


  ###
  List some articles collection

  @param {Model} model  some model that contains a nested articles collection
                        if null, the main collection will be loaded
  ###
  list: _.throttle (model, collection) ->
    region = @getRegion 'itemsList'

    # this action is a bit special because the list is always shown
    # so some considerations must be taken before rerendering it
    if @_shouldRenderList region, model, collection
      options = {}

      if model
        options.model = model
      else
        options.collection = collection or @getCollection()

        # set a flag for the custom collection
        if collection then @customCollectionLoaded = true

      # set the region where the controller's view will be rendered
      options.region = region

      new ListController options

    @getRegion('main').empty()

  , 1000, trailing: false


  ###
  @param {int}      id  model id
  @param {Category} category model
  ###
  listCategoryArticles: (id, category) ->
    model = if category then category else @appChannel.request 'kb:categories:entity', id
    @list model


  ###
  @param {int} id model id
  @param {Tag} tag model
  ###
  listTagArticles: (id, tag) ->
    model = if tag then tag else @appChannel.request 'kb:tags:entity', id
    @list model



  ###
  Create a new article
  ###
  create: ->
    new CreateController
      region:               @getRegion 'main'
      collection:           @getCollection()
      categoriesCollection: @getCategoriesCollection()
      tagsCollection:       @getTagsCollection()


  ###
  @param {int}     id model id
  @param {Article} article model
  ###
  edit: (id, article) ->
    new EditController
      id:                   id
      model:                article
      collection:           @getCollection()
      region:               @getRegion 'main'
      categoriesCollection: @getCategoriesCollection()
      tagsCollection:       @getTagsCollection()


  ###
  List all the articles that match some query

  @param {String} query
  ###
  search: (query) ->
    filterParam = StringUtil.escapeQueryParam query

    results = @appChannel.request 'kb:articles:entities',
      filters: ["search:#{filterParam}"]

    # add some custom attributes (so it can be rendered in a special way or whatever)
    results.isSearchResults = true
    results.searchQuery     = query

    @list null, results




  # Aux methods
  # ------------------------

  ###
  Collection getter
  ###
  getCollection: ->
    unless @collection
      @collection = @appChannel.request 'kb:articles:entities'
    @collection


  ###
  Categories collection getter

  Used when creating/editing articles (for the autocomplete feature) and maybe
  in for other purposes.
  Load it once and cache it until the user leaves the module
  ###
  getCategoriesCollection: ->
    unless @categoriesCollection
      @categoriesCollection = @appChannel.request 'kb:categories:entities'
    @categoriesCollection

  ###
  Tags collection getter

  Used when creating/editing articles (for the autocomplete feature) and maybe
  in for other purposes.
  Load it once and cache it until the user leaves the module
  ###
  getTagsCollection: ->
    unless @tagsCollection
      @tagsCollection = @appChannel.request 'kb:tags:entities'
    @tagsCollection


  ###
  Region getter

  @param  {String} region  The region name
  @return {Marionette.Region}
  ###
  getRegion: (region) ->
    layout = moduleChannel.request 'layout:get'
    layout.getRegion region


  ###
  Event handler invoked when the router becomes inactive (the loaded route
  no longer matches any of the routes deffined in that router)
  ###
  onInactive: ->
    delete @collection
    delete @categoriesCollection
    delete @tagsCollection


  ###
  Determine if the list shold be rerendered

  The list is always displayed when the module is active, so in order to avoid
  unnecessary renders, some checks must be performed
  ###
  _shouldRenderList: (region, model, collection) ->
    # if empty, render
    unless region.hasView() then return true

    # an entity (tag/category/whatever) has been provided
    if model or collection then return true

    # a custom collection was loaded (not all the articles,
    # maybe the search results or something)
    if @customCollectionLoaded
      @customCollectionLoaded = false
      return true

    # last check, if a collection has not been already loaded, render
    unless @collection then return true

    # default
    false
