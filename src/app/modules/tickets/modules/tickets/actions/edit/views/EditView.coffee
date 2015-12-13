# Dependencies
# -----------------------

# Libs/generic stuff:
_        = require 'underscore'
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Base class (extends Marionette.Controller)
CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'

# View behaviours
TaggableBehaviour = require 'msq-appbase/lib/behaviours/Taggable'

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


  triggers:
    'click #addComment':   'ticket:comment:add'
    'click #closeTicket':  'ticket:close'
    'click #reopenTicket': 'ticket:reopen'
    'click #changeStatus': 'ticket:status:change'
    'click #assignTicket': 'ticket:assign'


  ###
  @property {Object} model events
  ###
  modelEvents:
    'change': 'render'


  ###
  @property {Object} view behaviours config.
  ###
  behaviors:
    Taggable:
      behaviorClass: TaggableBehaviour


  ###
  @property {Object} form config.
  ###
  form:
    buttons: false
    footer: false
    focusFirstInput: false
