# Dependencies
# -----------------------

# Libs/generic stuff:
_        = require 'underscore'
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
ListView       = require './views/ListView'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Posts module, and the parent
# module channel.
kbChannel    = require '../../../../moduleChannel'
postsChannel = require '../../moduleChannel'

CategoryModel = require '../../../../entities/categories/Category'
TagModel      = require '../../../../entities/tags/Tag'


###
Knowledge Base posts module list controller
============================================

Controller responsible for posts listing.

This controller is responsible for instantiating views,
fetching entities (models/collections) and ensuring views
are configured properly.

When those views emit events throughout their lifecycle or
when something in particular happens which is important to
the application, this controller will listen for those
events and generally bubble those events up to the parent
module.

@class
@augments ViewController

###
module.exports = class ListController extends ViewController

  initialize: (options) ->
    { collection, model } = options

    # the view accepts an articles collection or a model
    # with a nested articles collection
    if model and !collection
      collection = model.get 'articles'
      # nested collections might not be initialised
      @appChannel.request 'when:fetched', model, ->
        if collection and collection.pending then collection.fetch()


    # create the view
    listView = @getView collection

    # setup events
    @listenTo listView, 'show', =>
      @setupViewEvents listView

    # render
    @show listView,
      loading:
        entities: [model, collection]

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    kbChannel.trigger 'section:changed', getActionMetadata model

    # refresh the list the user changes the language
    @listenTo @appChannel, 'locale:loaded', -> listView.render()


  # Aux
  # -----------------

  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Collection}
  @return {View}
  ###
  getView: (data) ->
    new ListView
      collection: data


  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @return {Object}
  ###
  getActionMetadata = (model) ->
    meta       = postsChannel.request 'meta'
    parentMeta = kbChannel.request 'meta'

    actionName = i18n.t 'List'

    if model
      if model instanceof CategoryModel
        actionName = i18n.t 'kb:::by category'
      if model instanceof TagModel
        actionName = i18n.t 'kb:::by tag'
    {
      parentModule:
        name: parentMeta.title()
        url:  parentMeta.rootUrl

      module:
        name: meta.title()
        url: meta.rootUrl

      action:    actionName
    }


  ###
  View events setup

  @param {View} view
  ###
  setupViewEvents: (view) =>
    @listenTo postsChannel, 'load:kb:post', (model) =>
      @API.postLoaded model, view

    @listenTo postsChannel, 'unload:kb:post', (model) =>
      @API.postUnloaded model, view

    @listenTo view, 'childview:edit:kb:post', (child, args) =>
      @API.editPost args.model

    @listenTo view, 'childview:delete:kb:post', (child, args) =>
      @API.deletePost args.model

    @listenTo view, 'childview:toggleActive:kb:post', (child, args) =>
      @API.togglePublishPost args.model

    @listenTo view, 'create:kb:post', ->
      @API.createPost()

    @listenTo view, 'kb:search:submit', ->
      @API.search(view)

    @listenTo view, 'kb:search:reset', ->
      @API.searchReset()


  API:
    ###
    Callback executed when an Article is loaded (to be edited or something)

    Highlights the matching Article on the Articles list

    @param {Article} model
    @param {ListView} view
    ###
    postLoaded: (model, view) ->
      if model
        childView = view.children.findByModel model
        if childView
          childView.highlightElement()

    ###
    Callback executed when an Article is unloaded

    Unhighlights the matching Article on the Articles list

    @param {Article} model
    @param {ListView} view
    ###
    postUnloaded: (model, view) ->
      if model
        childView = view.children.findByModel model
        if childView
          childView.unhighlightElement()
      kbChannel.trigger 'section:changed', getActionMetadata()

    ###
    Callback executed when the edit button on the childviews is clicked

    Bubbles up the event to the module so it can take the necessary actions

    @param {Article} model
    ###
    editPost: (model) ->
      postsChannel.trigger 'edit:kb:post', model

    ###
    Callback executed when the delete button on the childviews is clicked

    Bubbles up the event to the module so it can take the necessary actions

    @param {Article} model
    ###
    deletePost: (model) ->
      postsChannel.trigger 'delete:kb:post', model

    ###
    Callback executed when the create button on the list is clicked

    Bubbles up the event to the module so it can take the necessary actions
    ###
    createPost: ->
      postsChannel.trigger 'create:kb:post'

    ###
    Callback executed when the toggle publish button on the childviews is clicked

    @param {Article} model
    ###
    togglePublishPost: (model) ->
      newStatus = if model.get('publishStatus') is 'unpublished' then 'published' else 'unpublished'
      model.patch
        publishStatus: newStatus

    ###
    Search form submit handler
    ###
    search: (view) ->
      # pull data off of form
      data = Backbone.Syphon.serialize view

      # dispatch an event (it will be handled somewhere else)
      postsChannel.trigger 'kb:search', data

    ###
    Search form reset handler
    ###
    searchReset: ->
      postsChannel.trigger 'kb:search:reset'
