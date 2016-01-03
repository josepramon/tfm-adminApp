# Dependencies
# -----------------------

_       = require 'underscore'
channel = require 'msq-appbase/lib/utilities/appChannel'

# Base class
ModuleEntities = require 'msq-appbase/lib/appBaseComponents/modules/ModuleEntities'

# Entities
Ticket                         = require './tickets/Ticket'
TicketsCollection              = require './tickets/TicketsCollection'

UncategorisedTicket            = require './tickets/UncategorisedTicket'
UncategorisedTicketsCollection = require './tickets/UncategorisedTicketsCollection'

Category                 = require './categories/Category'
CategoriesCollection     = require './categories/CategoriesCollection'

Status                   = require './statuses/Status'
StatusesCollection       = require './statuses/StatusesCollection'

TicketStatus             = require './ticketStatuses/Status'
TicketStatusesCollection = require './ticketStatuses/StatusesCollection'

Comment                  = require './comments/Comment'
CommentsCollection       = require './comments/CommentsCollection'

Tag                      = require './tags/Tag'
TagsCollection           = require './tags/TagsCollection'

# general stats entities
Stats                    = require './stats/Stats'

# custom stats entities, exposing only the ByDateStats model,
# but there are more of them. Since they are not needed, because
# they're only used when embedded inside a Stats model, there's
# no point to expose them.
ByDateStats              = require './stats/ByDateStats'


###
Tickets entities submodule
===================================

Handles the instantiation of the entities exposed by this module.

###
module.exports = class TicketsEntities extends ModuleEntities

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
  factoryId: 'tickets:entities'


  ###
  @property {Object} Maps the identifiers to the classes
  ###
  factoryClassMap:
    'Ticket':                         Ticket
    'TicketsCollection':              TicketsCollection
    'UncategorisedTicket':            UncategorisedTicket
    'UncategorisedTicketsCollection': UncategorisedTicketsCollection

    'Category':                 Category
    'CategoriesCollection':     CategoriesCollection

    'Status':                   Status
    'StatusesCollection':       StatusesCollection

    'TicketStatus':             TicketStatus
    'TicketStatusesCollection': TicketStatusesCollection

    'Comment':                  Comment
    'CommentsCollection':       CommentsCollection

    'Tag':                      Tag
    'TagsCollection':           TagsCollection

    'Stats':                    Stats
    'ByDateStats':              ByDateStats


  ###
  Usually, when an entity is needed, it needs to be initialized with some defaults
  or with some state. This methods centralize this functionality here instead of
  disseminating it across multiple controllers and other files.
  ###
  handlers: =>
    # -------- Tickets --------
    'tickets:entities':   @_initializeTicketsCollection
    'tickets:entity':     @_initializeTicketModel
    'new:tickets:entity': @_initializeEmptyTicketModel

    'tickets:uncategorised:entity':   @_initializeUncategorisedTicketModel
    'tickets:uncategorised:entities': @_initializeUncategorisedTicketsCollection

    # -------- Categories --------
    'tickets:categories:entities':   @_initializeCategoriesCollection
    'tickets:categories:entity':     @_initializeCategoryModel
    'new:tickets:categories:entity': @_initializeEmptyCategoryModel

    # -------- Statuses --------
    'tickets:statuses:entities':   @_initializeStatusesCollection
    'tickets:statuses:entity':     @_initializeStatusModel
    'new:tickets:statuses:entity': @_initializeEmptyStatusModel

    'tickets:ticketStatuses:entities':   @_initializeTicketStatusesCollection
    'tickets:ticketStatuses:entity':     @_initializeTicketStatusModel
    'new:tickets:ticketStatuses:entity': @_initializeEmptyTicketStatusModel

    # -------- Comments --------
    'tickets:comments:entities':   @_initializeCommentsCollection
    'tickets:comments:entity':     @_initializeCommentModel
    'new:tickets:comments:entity': @_initializeEmptyCommentModel

    # -------- Tags --------
    'tickets:tags:entities':   @_initializeTagsCollection
    'tickets:tags:entity':     @_initializeTagModel
    'new:tickets:tags:entity': @_initializeEmptyTagModel

    # -------- Stats --------
    'tickets:stats:entity':       @_initializeStatsModel
    'tickets:stats:byDate:entity': @_initializeByDateStatsModel



  # Aux methods
  # ------------------------

  # handlers for the tickets entities:

  _initializeTicketsCollection: (options) =>
    defaults =
      filter: ['status:open']
      state:
        paginator:
          per_page: 10
      sort: 'updated_at|-1'

    @initializeCollection 'tickets:entities|TicketsCollection', _.defaults defaults, options

  _initializeTicketModel: (id, options) =>
    @initializeModel 'tickets:entities|Ticket', id, options

  _initializeEmptyTicketModel: =>
    @initializeEmptyModel 'tickets:entities|Ticket',
      user: @_getUserModel()

  _initializeUncategorisedTicketModel: (id, options) =>
    @initializeModel 'tickets:entities|UncategorisedTicket', id, options

  _initializeUncategorisedTicketsCollection: (options) =>
    @initializeCollection 'tickets:entities|UncategorisedTicketsCollection', options


  # handlers for the categories entities:

  _initializeCategoriesCollection: (options) =>
    @initializeCollection 'tickets:entities|CategoriesCollection', options

  _initializeCategoryModel: (id, options) =>
    @initializeModel 'tickets:entities|Category', id, options

  _initializeEmptyCategoryModel: =>
    @initializeEmptyModel 'tickets:entities|Category'

  # handlers for the status entities:

  _initializeStatusesCollection: (options) =>
    @initializeCollection 'tickets:entities|StatusesCollection', options

  _initializeStatusModel: (id, options) =>
    @initializeModel 'tickets:entities|Status', id, options

  _initializeEmptyStatusModel: =>
    @initializeEmptyModel 'tickets:entities|Status'

  # ticket status entities (a wrapper for status with the date, the user and other details)

  _initializeTicketStatusesCollection: (options) =>
    @initializeCollection 'tickets:entities|TicketStatusesCollection', options

  _initializeTicketStatusModel: (id, options) =>
    @initializeModel 'tickets:entities|TicketStatus', id, options

  _initializeEmptyTicketStatusModel: =>
    @initializeEmptyModel 'tickets:entities|TicketStatus',
      user: @_getUserModel()

  # handlers for the comments entities:

  _initializeCommentsCollection: (options) =>
    @initializeCollection 'tickets:entities|CommentsCollection', options

  _initializeCommentModel: (id, options) =>
    @initializeModel 'tickets:entities|Comment', id, options

  _initializeEmptyCommentModel: =>
    @initializeEmptyModel 'tickets:entities|Comment',
      user: @_getUserModel()

  # handlers for the tags entities:

  _initializeTagsCollection: (options) =>
    @initializeCollection 'tickets:entities|TagsCollection', options

  _initializeTagModel: (id, options) =>
    @initializeModel 'tickets:entities|Tag', id, options

  _initializeEmptyTagModel: =>
    @initializeEmptyModel 'tickets:entities|Tag'

  # handlers for the stats entities:

  _initializeStatsModel: (options) =>
    @initializeModel 'tickets:entities|Stats', null, options

  _initializeByDateStatsModel: (options) =>
    @initializeModel 'tickets:entities|ByDateStats', null, options


  ###
  User model getter

  @return {Session} the session model
  ###
  _getUserModel: ->
    user    = null
    session = @appChannel.request 'user:session:entity'

    if session
      user = session.get 'user'

    user
