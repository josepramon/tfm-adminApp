# Dependencies
# -----------------------

_       = require 'underscore'
channel = require 'msq-appbase/lib/utilities/appChannel'

# Base class
ModuleEntities = require 'msq-appbase/lib/appBaseComponents/modules/ModuleEntities'

# Entities
Manager            = require './managers/Manager'
ManagersCollection = require './managers/ManagersCollection'

User            = require './users/User'
UsersCollection = require './users/UsersCollection'



###
Manager entities submodule
==========================

Handles the instantiation of the entities exposed by the managers module.

###
module.exports = class ManagersEntities extends ModuleEntities

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
  factoryId: 'users:entities'


  ###
  @property {Object} Maps the identifiers to the classes
  ###
  factoryClassMap:
    'Manager'            : Manager
    'ManagersCollection' : ManagersCollection

    'User'            : User
    'UsersCollection' : UsersCollection



  ###
  Usually, when an entity is needed, it needs to be initialized with some defaults
  or with some state. This methods centralize this functionality here instead of
  disseminating it across multiple controllers and other files.
  ###
  handlers: =>
    # -------- Managers --------
    'managers:entities':     @_initializeManagersCollection
    'managers:entity':       @_initializeManagerModel
    'new:managers:entity':   @_initializeEmptyManagerModel

    'users:entities':     @_initializeUsersCollection
    'users:entity':       @_initializeUserModel



  # Aux methods
  # ------------------------

  # handlers for the users related entities:

  _initializeManagersCollection: (options) =>
    @initializeCollection 'users:entities|ManagersCollection', options

  _initializeManagerModel: (id, options) =>
    @initializeModel 'users:entities|Manager', id, options

  _initializeEmptyManagerModel: =>
    @initializeEmptyModel 'users:entities|Manager'


  _initializeUsersCollection: (options) =>
    @initializeCollection 'users:entities|UsersCollection', options

  _initializeUserModel: (id, options) =>
    @initializeModel 'users:entities|User', id, options
