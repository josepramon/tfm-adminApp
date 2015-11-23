# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# Helpers
CategoriesHelper = require 'msq-appbase/lib/helpers/CategorizableModelControllerHelper'
TagsHelper       = require 'msq-appbase/lib/helpers/TaggableModelControllerHelper'

# The view
CreateView = require './views/CreateView'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Posts module, and the parent
# module channel.
kbChannel    = require '../../../../moduleChannel'
postsChannel = require '../../moduleChannel'


###
Article module create controller
================================

Controller responsible for Article creation

This controller is responsible for instantiating views,
fetching entities (models/collections) and ensuring views
are configured properly.

When those views emit evnts throughout their lifecycle or
when something in particular happens which is important to
the application, this controller will listen for those
events and generally bubble those events up to the parent
module.

@class
@augments ViewController

###
module.exports = class CreateController extends ViewController

  initialize: (options) ->
    { collection, tagsCollection, categoriesCollection } = options

    model = @getModel()

    # create the view
    view = @getView model

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    @listenTo view, 'show', =>
      kbChannel.trigger 'section:changed', @getActionMetadata()

    # wrap it into a form component
    formView = @wrapViewWithForm(view, model, collection)

    # The entire uploads collection is returned, stringified
    # Convert it back to an object before processing it
    @listenTo formView, 'form:submit', (data) ->
      if data.attachments
        newVal = null
        try
          newVal = JSON.parse data.attachments
        catch e
          console.log 'Bad attachments value'
        data.attachments = newVal
        data

    # Syphon returns the tags and category a string.
    # Convert it back to the collection before saving the model
    @setupRelatedTags     model, tagsCollection,       view, formView
    @setupRelatedCategory model, categoriesCollection, view, formView

    # render
    @show formView,
      loading:
        entities: [model, tagsCollection, categoriesCollection]



  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @param  {Model}
  @return {Object}
  ###
  getActionMetadata: () ->
    meta = postsChannel.request 'meta'
    parentMeta = kbChannel.request 'meta'

    {
      parentModule:
        name: parentMeta.title()
        url:  parentMeta.rootUrl

      module:
        name: meta.title()
        url: meta.rootUrl

      action:    i18n.t 'Create'
    }



  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Model}
  @return {View}
  ###
  getView: (data) ->
    new CreateView
      model: data

  ###
  Load the model
  ###
  getModel: () ->
    @appChannel.request 'new:kb:articles:entity'



  ###
  Form setup

  Wraps the view inside a FormComponent that handles the
  serializing/deserializing, validation and other stuff.

  @param {View}       view
  @param {Model}      model
  @param {Collection} collection
  ###
  wrapViewWithForm: (view, model, collection) ->
    @appChannel.request 'form:component', view,
      collection:       collection
      onFormCancel:  => @formActionDone()
      onFormSuccess: => @formActionDone(true)



  ###
  Callback executed when the form is closed
  ###
  formActionDone: (success = false) ->
    if success
      flashMessage = i18n.t 'kb:::Article successfully created'
      @appChannel.request 'flash:success', flashMessage
    @region.empty()
    postsChannel.trigger 'done:kb:post'



  ###
  Related categories helper setup
  ###
  setupRelatedCategory: (model, categoriesCollection, view, formView) ->
    # inject the collection to the view (for the autocompletion)
    view.availableCategories = categoriesCollection

    @categoriesHelper = new CategoriesHelper
      model:      model
      collection: categoriesCollection
      formView:   formView
      options:
        categoryFactory: 'new:kb:categories:entity'



  ###
  Related tags helper setup
  ###
  setupRelatedTags: (model, tagsCollection, view, formView) ->
    # inject the collection to the view (for the autocompletion)
    view.availableTags = tagsCollection

    @tagsHelper = new TagsHelper
      model:        model
      collection:   tagsCollection
      formView:     formView
      options:
        tagFactory: 'new:kb:tags:entity'



  destroy: ->
    @categoriesHelper.destroy()
    @tagsHelper.destroy()
    super
