# Dependencies
# -----------------------

# Libs/generic stuff:
_        = require 'underscore'
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
EditView = require './views/EditView'

# Helpers
TagsHelper = require 'msq-appbase/lib/helpers/TaggableModelControllerHelper'

# Aux.
CommentController = require '../comment/CommentController'
StatusController  = require '../status/StatusController'

# Radio channels:
ticketsChannel = require '../../moduleChannel'


###
Tickets module edit controller
====================================

@class
@augments ViewController

###
module.exports = class EditController extends ViewController

  initialize: (options) ->
    { model, collection, statuses, tags } = options

    # create the view
    view = @getView model

    # bind the listeners
    @_bindViewEvents view
    @listenTo model.get('statuses'), 'add', view.render

    # wrap it into a form component
    formView = @wrapViewWithForm(view, model, collection)

    # Syphon returns the tags and category a string.
    # Convert it back to the appropiate entities before saving the model
    @setupRelatedTags model, tags, view, formView

    # render
    @show formView,
      loading:
        loading: [model, collection, statuses]

    # save some references as instance attributes
    @model    = model
    @statuses = statuses


  ###
  View events binding
  ###
  _bindViewEvents: (view) ->
    @listenTo view, 'ticket:comment:add',   @createComment
    @listenTo view, 'ticket:close',         @closeTicket
    @listenTo view, 'ticket:reopen',        @reopenTicket
    @listenTo view, 'ticket:assign',        @autoAssignTicket
    @listenTo view, 'ticket:status:change', @setNewStatus


  ###
  Assign the ticket to the logged agent
  ###
  autoAssignTicket: ->
    user    = null
    session = @appChannel.request 'user:session:entity'

    if session
      user = session.get 'user'
      if user then @model.patch manager: user


  ###
  Add a new comment to the ticket
  ###
  createComment: =>
    new CommentController
      parentModel: @model
      region:      @appChannel.request 'region', 'modalRegion'


  ###
  Close the ticket (add a 'closed' status)
  ###
  closeTicket: ->
    closedStatusModel = @statuses.findWhere 'closed': true

    @_changeStatus
      model:    closedStatusModel
      callback: =>
        @model.set 'closed': true
        Backbone.history.navigate '#tickets', { trigger: true }


  ###
  Reopen the ticket (add an 'apen' status)
  ###
  reopenTicket: ->
    openStatusModel = @statuses.findWhere 'open': true

    @_changeStatus
      model:    openStatusModel
      callback: =>
        @model.set 'closed': false



  ###
  Add some new status to the ticket
  ###
  setNewStatus: ->
    currentStatus = _.last(@model.get('statuses').models).get 'status'

    filteredCollection = @statuses.filter (model) ->
      return !model.get('closed') and !model.get('open') and !(model.id is currentStatus.id)

    if !filteredCollection.length
      # coffeelint: disable=max_line_length
      msg = i18n.t 'tickets:::There are no more available custom ticket statuses. To close the ticket click the "close" button.'
      # coffeelint: enable=max_line_length
      @appChannel.request 'dialogs:alert', msg
      return

    @_changeStatus
      collection: new Backbone.Collection filteredCollection
      callback: (model) =>
        status = model.get 'status'
        if status.get('open')   then @model.set 'closed': false
        if status.get('closed') then @model.set 'closed': true


  ###
  Change the ticket status
  ###
  _changeStatus: (options = {}) ->
    # default callback
    callback = _.noop

    # default controller args
    args =
      statusesCollection: @statuses
      parentModel:        @model
      region:             @appChannel.request 'region', 'modalRegion'

    if options.model      then args.statusModel        = options.model
    if options.collection then args.statusesCollection = options.collection
    if options.callback   then callback                = options.callback

    # instantiate the controller
    controller = new StatusController args

    @listenToOnce controller, 'status:created', (model) =>
      callback model
      @model.get('statuses').add model
      @model.save()


  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param {Model} model
  @return {View}
  ###
  getView: (model) ->
    new EditView
      model:      model
      collection: model.get 'comments'



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
      flashMessage = i18n.t 'tickets:::Ticket successfully updated'
      @appChannel.request 'flash:success', flashMessage



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
        tagFactory: 'new:tickets:tags:entity'



  destroy: ->
    @tagsHelper.destroy()
    super
