# Dependencies
# -----------------------

# Libs/generic stuff:
_        = require 'underscore'
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Base class (extends Marionette.Controller)
CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'

# Aux. views
CommentView    = require './CommentView'
NoCommentsView = require './NoCommentsView'



###
Tickt view
==============================

@class
@augments CompositeView

###
module.exports = class TicketView extends CompositeView
  template: require './templates/ticket.hbs'

  childViewContainer: '.ticketComments .comments'
  childView: CommentView
  emptyView: NoCommentsView


  ###
  @property {Object} model events
  ###
  modelEvents:
    'change': 'render'


  ###
  @property {Object} form config.
  ###
  form:
    buttons: false
    footer: false


  ###
  Inject some additional data
  ###
  serializeData: ->
    ret = @model.toJSON()
    ret.categories = @categories.invoke 'pick', 'id', 'name'
    ret


  initialize: (options) ->
    @categories = options.categories
    super()
