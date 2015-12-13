# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
CommentFormView = require './views/CommentFormView'

# Radio channels:
ticketsChannel = require '../../moduleChannel'


###
Tickets comment controller
====================================

@class
@augments ViewController

###
module.exports = class CommentController extends ViewController

  initialize: (options) ->
    { parentModel, region } = options

    commentsCollection = parentModel?.get('comments')

    # get the comment model
    model = @getModel commentsCollection

    # create the view
    view = @getView model

    # wrap it into a form component
    formView = @wrapViewWithForm view, model, commentsCollection

    # setup bindings
    @listenTo formView, 'form:submit', @processFormData

    # show the view
    opts = if region then { region: region } else {}

    @show formView, opts


  ###
  Initialize the comment model
  ###
  getModel: (collection) ->
    model = @appChannel.request 'new:tickets:comments:entity'

    # override the model url if it belongs to some nested collectio
    if collection then model.urlRoot = collection.url

    model


  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param {Model} model
  @return {View}
  ###
  getView: (model) ->
    new CommentFormView
      model: model


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
      onFormCancel:  => @formActionDone(view)
      onFormSuccess: => @formActionDone(view, true)
      proxy: 'modal'


  ###
  Callback executed when the form is closed
  ###
  formActionDone: (view, success = false) =>
    if success
      flashMessage = i18n.t 'tickets:::Ticket successfully saved'
      @appChannel.request 'flash:success', flashMessage

    # this controller view might be displayed inside a modal
    # so trigger an event and if the view is inside the modal
    # it will be closed. Otherwise, nothing will happen
    view.triggerMethod 'modal:close'


  ###
  Form submit handler

  Preprocess the data before the generic handlers are executed
  ###
  processFormData: (data) ->
    # process the attachments
    data.attachments or= {}
    newVal = null
    try
      newVal = JSON.parse data.attachments
    catch e
      console.log 'Bad attachments value'
    data.attachments = newVal
