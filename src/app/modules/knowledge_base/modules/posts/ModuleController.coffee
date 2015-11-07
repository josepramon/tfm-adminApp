# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Controller       = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

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

  list: ->
    # this action is a bit special because the list is always shown
    region = @getRegion 'itemsList'

    unless region.hasView()
      new ListController
        region:     region
        collection: @getCollection()

    @getRegion('main').empty()


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
