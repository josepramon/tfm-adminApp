# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
StatusFormView = require './views/StatusFormView'

# Radio channels:
ticketsChannel = require '../../moduleChannel'


###
Tickets status controller
====================================

@class
@augments ViewController

###
module.exports = class StatusController extends ViewController

  initialize: (options) ->
    { statusModel, statusesCollection, parentModel, region } = options

    parentStatusesCollection = parentModel?.get('statuses')

    # get the new status model
    model = @getModel statusModel, parentStatusesCollection

    # create the view
    view = @getView model, parentStatusesCollection, statusesCollection

    # wrap it into a form component
    formView = @wrapViewWithForm view, model, parentStatusesCollection

    # setup bindings
    @listenTo formView, 'form:submit', @processFormData

    # show the view
    opts = if region then { region: region } else {}

    @show formView, opts

    # save some references
    @view = view
    @ticketStatusModel  = model
    @statusesCollection = statusesCollection


  ###
  Initialize the comment model
  ###
  getModel: (statusModel, collection) ->
    model = @appChannel.request 'new:tickets:ticketStatuses:entity'

    # preset the status if supplied
    if statusModel then model.set { status: statusModel }

    # override the model url if it belongs to some nested collection
    if collection then model.urlRoot = collection.url

    model


  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param {TicketStatus}             model
  @param {TicketStatusesCollection} collection
  @param {StatusesCollection}       statusesCollection
  @return {View}
  ###
  getView: (model, collection, statusesCollection) ->
    new StatusFormView
      model:              model
      collection:         collection
      statusesCollection: statusesCollection


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
      proxy: 'modal'


  ###
  Callback executed when the form is closed
  ###
  formActionDone: (success = false) ->
    if success
      flashMessage = i18n.t 'tickets:::Ticket successfully updated'
      @appChannel.request 'flash:success', flashMessage

    # this controller view might be displayed inside a modal
    # so trigger an event and if the view is inside the modal
    # it will be closed. Otherwise, nothing will happen
    @trigger 'status:created', @ticketStatusModel
    @view.triggerMethod 'modal:close'


  ###
  Form submit handler

  Preprocess the data before the generic handlers are executed
  ###
  processFormData: (data) ->
    # process the status
    if data.status
      data.status = @statusesCollection.get data.status
