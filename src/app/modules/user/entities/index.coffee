# Dependencies
# -----------------------

# Local/Session storage adapter for Backbone
WebStorage = require 'backbone.webStorage'

# Entities
SessionModel                      = require './Session'
UserLoginModel                    = require './UserLogin'
RegisterModel                     = require './Register'
PasswordRecoveryModel             = require './PasswordRecovery'
PasswordRecovery_NewPasswordModel = require './PasswordRecoveryPassword'
AccountActivationModel            = require './AccountActivation'




###
User entities management
=============================
###
module.exports = (Module, App, Backbone, Marionette, $, _) ->

  # the session model is a singleton
  session = null

  API =
    ###
    Session model getter

    @return {SessionModel} the session model (it's a singleton)
    ###
    getSessionModel: ->
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
              App.channel.trigger 'user:session:entity:destroyed'

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
    newLoginModel: ->
      new UserLoginModel

    ###
    @return {RegisterModel}
    ###
    newRegisterModel: ->
      new RegisterModel

    ###
    @return {PasswordRecoveryModel}
    ###
    newPasswordRecoveryModel: ->
      new PasswordRecoveryModel

    ###
    @return {PasswordRecovery_NewPasswordModel}
    ###
    newPasswordSetModel: (id) ->
      new PasswordRecovery_NewPasswordModel
        id: id

    ###
    @return {newAccountActivationModel}
    ###
    newAccountActivationModel: (id) ->
      new AccountActivationModel
        id: id


  App.channel.reply 'user:session:entity', ->
    API.getSessionModel()

  App.channel.reply 'user:login:entity', ->
    API.newLoginModel()

  App.channel.reply 'user:register:entity', ->
    API.newRegisterModel()

  App.channel.reply 'user:passwordRecovery:entity', ->
    API.newPasswordRecoveryModel()

  App.channel.reply 'user:passwordRecoveryPassword:entity', (id) ->
    API.newPasswordSetModel id

  App.channel.reply 'user:accountActivation:entity', (id) ->
    API.newAccountActivationModel id
