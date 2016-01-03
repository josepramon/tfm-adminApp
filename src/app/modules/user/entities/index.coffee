# Dependencies
# -----------------------

_        = require 'underscore'
channel  = require 'msq-appbase/lib/utilities/appChannel'
Backbone = require 'backbone'

# Local/Session storage adapter for Backbone
WebStorage = require 'backbone.webStorage'

# Base class
ModuleEntities = require 'msq-appbase/lib/appBaseComponents/modules/ModuleEntities'

# Entities
SessionModel                      = require './Session'
UserModel                         = require './User'
UserLoginModel                    = require './UserLogin'
RegisterModel                     = require './Register'
PasswordRecoveryModel             = require './PasswordRecovery'
PasswordRecovery_NewPasswordModel = require './PasswordRecoveryPassword'
AccountActivationModel            = require './AccountActivation'
ProfileModel                      = require './Profile'


# the session model is a singleton
session = null


###
User entities management
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
  factoryId: 'user:entities'


  ###
  @property {Object} Maps the identifiers to the classes
  ###
  factoryClassMap:
    'Session':                  SessionModel
    'User':                     UserModel
    'UserLogin':                UserLoginModel
    'Register':                 RegisterModel
    'PasswordRecovery':         PasswordRecoveryModel
    'PasswordRecoveryPassword': PasswordRecovery_NewPasswordModel
    'AccountActivation':        AccountActivationModel
    'Profile':                  ProfileModel



  ###
  Usually, when an entity is needed, it needs to be initialized with some defaults
  or with some state. This methods centralize this functionality here instead of
  disseminating it across multiple controllers and other files.
  ###
  handlers: =>
    'user:session:entity':                  @_getSessionModel
    'user:login:entity':                    @_newLoginModel
    'user:register:entity':                 @_newRegisterModel
    'user:passwordRecovery:entity':         @_newPasswordRecoveryModel
    'user:passwordRecoveryPassword:entity': @_newPasswordSetModel
    'user:accountActivation:entity':        @_newAccountActivationModel




  ###
  Session model getter

  @return {SessionModel} the session model (it's a singleton)
  ###
  _getSessionModel: ->
    unless session
      session = new SessionModel

      # This is a special model, not persisted on the backend
      # (in fact it might be cached on redis or something).
      #
      # This model should be stored locally, using local or session storage.
      # This is being set here instead of the model deffinition itself because
      # on the web version the session should be destroyed when the browser is
      # closed, but on a future mobile app this should persist.
      #
      # TODO: when developing the future mobile app, set some flag on the App
      # instance, and then assign a localStorage or sessionStorage adapter
      # according to that flag
      #
      # The persistence is implemented using
      # [Backbone.webStorage](https://github.com/glensomerville/Backbone.webStorage),
      # a fork of Backbone.localStorage that implements both localStorage and
      # sessionStorage. The first param is the key in the webstore and the second
      # one is the storage adapter ('localStorage' or 'sessionStorage').
      session.localStorage = new WebStorage 'session', 'sessionStorage'

      # Overwrite the idAttribute when accessing the sessionStorage because
      # this model is a singleton therefore it's ID must persist
      session.idAttribute = 'storageId'
      session.set 'storageId', 0

      # the previous chanche breaks the API communication
      session.url = () ->
        return session.urlRoot + '/' + session.get 'token'

      _sync = session.sync

      # the logout call should call the server AND remove the key from the local store
      # but backbone.webStorage only does one method OR the other
      session.sync = (method, entity, options) ->
        if method isnt 'delete'
          # just the regular behaviour
          _sync(method, entity, options)
        else
          model = @
          args  = arguments
          destroyLocalSession = ->
            Backbone.localSync.apply model, args
            session = null
            sessionStorage.clear()
            channel.trigger 'user:session:entity:destroyed'

          if options.local
            # remove only locally
            destroyLocalSession()
          else

            # first invalidate the token on the server
            # and when done destroy the session locally
            opts = _.clone options
            opts.complete = -> destroyLocalSession()

            Backbone.ajaxSync.apply @, [method, entity, opts]

    session

  ###
  @return {UserLoginModel}
  ###
  _newLoginModel: =>
    @initializeEmptyModel 'user:entities|UserLogin'

  ###
  @return {RegisterModel}
  ###
  _newRegisterModel: =>
    @initializeEmptyModel 'user:entities|Register'

  ###
  @return {PasswordRecoveryModel}
  ###
  _newPasswordRecoveryModel: =>
    @initializeEmptyModel 'user:entities|PasswordRecovery'

  ###
  @return {PasswordRecovery_NewPasswordModel}
  ###
  _newPasswordSetModel: (id) =>
    @initializeEmptyModel 'user:entities|PasswordRecoveryPassword', id: id

  ###
  @return {newAccountActivationModel}
  ###
  _newAccountActivationModel: (id) =>
    @initializeEmptyModel 'user:entities|AccountActivation', id: id
