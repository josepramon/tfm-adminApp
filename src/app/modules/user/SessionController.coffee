Controller = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'


module.exports = class SessionController extends Controller

  ###
  Controller initialization
  ###
  initialize: ->

    # Initialize the session model (it's a singleton)
    @session = @getSessionModel()
    @setupSessionListeners @session

    # Session handlers
    @appChannel.reply 'auth:isAuthenticated', => @session.isAuthenticated()
    @appChannel.reply 'auth:logout',          => @session.destroy()
    @appChannel.reply 'auth:requireAuth',     @checkAccess

    # Try to load the session from localStorage
    @session.fetch()

    # When initializing the app, check if the user is authenticated
    # If not, destroy the session
    if !@session.isAuthenticated()
      @session.destroy
        local: true



  ###
  Session model getter

  @return {Session} the session model
  ###
  getSessionModel: ->
    @appChannel.request 'user:session:entity'


  ###
  Session model listeners setup

  @param {Session} the session model
  ###
  setupSessionListeners: (session) =>

    # Whenever an auth error is detected, destroy the session
    @listenTo session, 'authError', () ->
      # session expired, destroy it
      @session.destroy
        local: true


    # When the session is destroyed broadcast an event so other modules can stop,
    # or the login route can be triggered or whatever
    @listenTo session, 'destroy', () =>
      @cancelSessionRenew()
      @appChannel.trigger 'auth:unauthenticated'


    # Autorenew the session before it expires
    @listenTo session, 'change:token_exp', () =>
      @sessionRenew(@session)


    # Whenever the session gets COMPLETELY destroyed
    # get a new instance and rebind to it
    #
    # The session 'destroy' event is not enought because the session is saved
    # on sessionStorage and is persisted on the server, and when destroying the
    # session the event s triggered twice
    @listenTo @appChannel, 'user:session:entity:destroyed', =>
      # get a new instance and listen to its events
      @session = @appChannel.request 'user:session:entity'
      @setupSessionListeners @session



  ###
  Prevent session expiration by autorenewing before the session expires

  @param {Session} the session model
  ###
  sessionRenew: (session) =>
    if session.isExpired() then return

    currentDate = new Date()
    expiryDate  = new Date(session.get 'token_exp')

    # renew the token 4 minutes before it expires
    securityTimeout = 4 * 60 * 1000

    # time before the session expires
    remainingTime  = expiryDate - currentDate

    # substract the security timeout
    remainingTime -= securityTimeout

    # if the session is still valid but it's about to expire
    # (the security timout has been exceeded) renew it right away
    remainingTime = 0 if remainingTime < 0

    # cancel any scheduled renewal
    @cancelSessionRenew()

    # schelude the renovation
    @sessionRenewTimer = setTimeout (->
      session.renew null, destroy
    ), remainingTime

    # internal funct.
    destroy = -> session.destroy()



  ###
  Cancel the renovation schelude
  ###
  cancelSessionRenew: () ->
    clearTimeout @sessionRenewTimer


  ###
  Access control based on the user privileges

  If there's no user session (the user is not authenticated),
  it will also trigger an event (to force the login or whatever)

  @param {Object}  privileges  Hash of required privileges
  @param {Boolean} silent      If false, it will trigger auth error events.
                               This is useful for example to restrict access to
                               some routes without needing to deffine repeatedly
                               the error handlers. Instead, a generic error handler
                               can be used to redirect the user to a error view
                               or display an alert or whatever.

  @return {Boolean}
  ###
  checkAccess: (privileges, silent = true) =>
    authorised = false

    if @session && @session.isAuthenticated()
      authorised = @session.hasAccess(privileges)

      if !authorised and !silent
        @appChannel.trigger 'auth:accessDenied'

    else
      # no session
      if !silent
        @appChannel.trigger 'auth:unauthenticated'

    authorised
