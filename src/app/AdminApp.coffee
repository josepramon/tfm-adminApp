###

MosaiqoCMS App
================
v0.0.0

Copyright (c) Mosaiqo
MosaiqoCMS may be freely distributed under the MIT license.

http://www.mosaiqo.com

###


# Dependencies
# -------------------------

i18n = require 'i18next-client'

# Application configuration
config        = require 'config/app'
localesConfig = require 'config/locales'

# set the appLib params
require('msq-appbase/lib/config').extend config, localesConfig

# Base class (extends Marionette.Application)
Application = require 'msq-appbase/lib/appBaseComponents/Application'

# Register the template generic partials
require 'views/tmplPartials'

# Regions has been depprecated, so using a layout instead
AppLayoutView = require 'views/layouts/App'

# Components and utilities modules are composed by multiple definition files.
# This arrays are used to init them all in a cleaner way.
utilities  = [
  # Internationalization helpers
  require 'msq-appbase/lib/utilities/i18n'

  # Entities fetch callbacks
  require 'msq-appbase/lib/utilities/fetch'

  # Backbone.history helpers
  require 'msq-appbase/lib/utilities/navigation'

  # Controller registry to keep track of instantiated controllers
  require 'msq-appbase/lib/utilities/registry'

  # Backbone.validation setup
  require 'msq-appbase/lib/utilities/validation'

  # Backbone.syphon setup
  require 'msq-appbase/lib/utilities/viewsSerialization'

  # Loads and registers the modules deffined in config/modules
  require 'msq-appbase/lib/utilities/moduleLoader'

  # Utility to setup the API requests,
  # because the API server might be anywhere
  require 'msq-appbase/lib/utilities/httpRequestUrlTransformer'

  # Utility to catch http errors
  require 'msq-appbase/lib/utilities/httpErrorHandler'

  # Flash messages
  require 'msq-appbase/lib/utilities/flash'

  # Dialogs (custom alerts, confirms, prompts, etc)
  require 'msq-appbase/lib/utilities/dialogs'
]
components = [
  # Generic form component
  require 'msq-appbase/lib/components/form'

  # Loading view, defers the rendering until entities are loaded
  require 'msq-appbase/lib/components/loading'

  # Uploader component, provides a nice UI with drag & drop, progressbars, etc
  require 'msq-appbase/lib/components/uploader'
]




###
AdminApp application class
------------------------------

@class
@augments Application

###
module.exports = class AdminApp extends Application

  ###
  @property {String} Application ID (used on some requests to the API)
  ###
  applicationID: 'adminsAPP'

  ###
  @property {String} Default channel used by backbone.radio
  ###
  channelName: config.appChannel

  ###
  @property {String} Default initial route
       (empty, it will be overwritten once the modules are loaded)
  ###
  rootRoute: ''



  ###
  Application initialization

  @param  {Object} options      initialization options
  @option {String} environment  app environtment, controls logging and other stuff
  @option {String} apiRootUrl   API base url (null by default, so the calls are
                                performed on /api/whatever)
  ###
  initialize: (options = {}) ->
    # Set the env.
    @environment = options?.environment or 'production'

    # Init the main layout
    @setupApplicationLayout()

    # Initialize the modules
    @setupApplicationModules options

    # Setup the API communication
    @setupAPI options?.apiRootUrl

    # Overwrite the rootRoute
    if @Dashboard
      @rootRoute = @module('Dashboard').meta.rootUrl

    # Show a warning when a HTTP error happens
    @listenTo @channel, 'http:error', (args) =>
      @channel.request 'flash:error', args.errorThrown, args.textStatus,
        preventDuplicates: true

    # App id getter
    @channel.reply 'application:id', => @applicationID


    ###
    TMP: default language. This goes in the settings module
    ###
    @channel.reply 'languages:default', -> 'en'
    @channel.reply 'languages:all', ->
      'en' : 'English',
      'es' : 'Castellano',
      'ca' : 'Català'



  ###
  Event handler executed after the app has been initialized

  @param {Object} options    initialization options
  ###
  onStart: (options) ->

    # At this point all the modules should be loaded. If the session already
    # exists (saved on the localStorage), trigger the isAuthenticated event so
    # the other modules start and th initial route can be navigated.
    # Although @request 'auth:isAuthenticated' returns true, that does not mean
    # that the session is in fact valid, becaus it could be invalidated serverside.
    # Anyway, any request to the API should return an error in that situation
    # and that will be handled by destroying the local session.
    #
    # The events auth:authenticated and auth:unauthenticated should only be triggered
    # from the UserModule, but the app initialization is a valid exception to the rule.
    if @channel.request 'auth:isAuthenticated'
      @channel.trigger 'auth:authenticated'

    # Initialize app nav.
    @loginRoute = @channel.request 'auth:routes:login'
    @errorRoute = @channel.request 'auth:routes:error'
    @activationRoute = /^user\/activate\//i

    @setupAuthNavigationHooks()

    # trigger the initial route
    @startNavigation()



  ###
  API communication setup

  The models and collections have deffined the API URLs to something like '/api/foo'.
  This allows to transform that URLs, like adding a prefix for versioning, or
  pointing it to another directory or domain. When assigning a new domain, this
  will setup the required CORS headers

  @param {String} apiRootUrl   API base url (null by default, so the calls are
                               performed on /api/whatever)
  ###
  setupAPI: (apiRootUrl) ->
    if config.API.rootURL or apiRootUrl
      base = apiRootUrl or config.API.rootURL
      @httpRequestUrlTransform '/api', base

      # The API may respond sometimes with new URLs that need
      # to be transformed to make them consistent with the ones
      # defined in the app  in order to automatically apply some
      # filters, like injecting authorization headers or whatever
      @channel.reply 'api:url:clean', (url) -> url.replace base, '/api'

      # The communication with the API is performed using jQuery
      # (Backbone internally uses this), so all the API URLs are
      # defined like `/api/whatever`, and with a prefilter, they're
      # automatically rewritten to match the API base URL defined in
      # the aplication preferences, so there's no need to update the
      # url in multiple files.
      #
      # In some situations, a raw XMLHttpRequest object may be used instead
      # of the jQuery provided one (for example some libraries don't use jQuery),
      # so, provide a method to obtain the appropiate url.
      @channel.reply 'api:url:setBase', (url) -> url.replace '/api', base



  ###
  Application modules initialization

  Registers and initializes the modules

  @param {Object} options    initialization options
  ###
  setupApplicationModules: (options = {}) ->

    ###
    @type {Array} Array with the application modules to register/initialize

    Used by the moduleLoader (from the Utilities module), that will load and
    initialize the application submodules deffined on `config/modules`

    @see lib/util/moduleLoader
    ###
    @modulesRegistry = options?.modules or []

    # ### Compose the Utilities and Components modules:
    #
    # The Utilities module is a special module that registers some handlers on
    # the application radio channel or just setup some application logic
    # on initialization. The module does not expose directly anything.
    #
    # The components module contains some general submodules like the
    # FormComponent or the LoadingViewComponent used by other modules.
    @module 'Utilities',  moduleDefinition for moduleDefinition in utilities
    @module 'Components', moduleDefinition for moduleDefinition in components

    # The modules might have some locale namespaces that need to be loaded
    @channel.request 'locale:loadModulesNS', @modulesRegistry



  ###
  Main layout initialization

  (application regions are deprecated)
  ###
  setupApplicationLayout: ->
    @layout = new AppLayoutView()

    # region getters
    @channel.reply 'default:region',  => @layout.getRegion 'mainRegion'
    @channel.reply 'region', (region) => @layout.getRegion region

    # layout 'collapsing' (nav hidden and small logo)
    @listenTo @channel, 'layout:collapse', (collapse) =>
      @layout.collapse collapse

    @listenTo @channel, 'auth:unauthenticated', => @layout.setAuthenticationStatus false
    @listenTo @channel, 'auth:authenticated',   => @layout.setAuthenticationStatus true

    @layout.render()



  ###
  App routing
  ###
  startNavigation: ->
    # start listening to Backbone History
    @startHistory()

    # if the user changes the language,
    # trigger the same route to re-render everything
    # add a little timeout to avoid a reroute on the app startup
    setTimeout (=>
      @listenTo @channel, 'locale:loaded', => @reloadRoute()
    ), 5000


    # ### Navigate to the initial route (if authorised)
    #
    # Using `unless... else...` instead of `if... else...` to avoid the user module
    # dependency. If the user module is removed for whatever reason (i can't think
    # of a valid reason, but anyway) this will keep working correctly.
    unless @channel.request 'auth:isAuthenticated'
      @channel.trigger 'auth:unauthenticated'
    else
      # Navigate us to the root route unless we're already navigated somewhere else.
      # If the route is the login one and the user is already authenticated, navigate
      # to the default initial route.
      initialRoute = @getCurrentRoute()

      if (initialRoute is @loginRoute) or !!initialRoute.match(@activationRoute)
        initialRoute = @rootRoute

      @navigate(initialRoute, trigger: true)



  ###
  Authentication event hooks:

  Listen to the login/logout events and redirect to the appropiate routes
  ###
  setupAuthNavigationHooks: ->
    prevRoute  = null

    # redirect to the login route if the user is not authenticated
    @listenTo @channel, 'auth:unauthenticated', =>
      # save the previous route so the user can be redirected
      # to where it was once authenticated
      prevRoute = @getCurrentRoute() or @rootRoute

      # send the user to the login route (unless the previous route was the
      # user activation one, which is the only public route, for now, at least)
      destRoute = if !!prevRoute.match(@activationRoute) then prevRoute else @loginRoute

      @navigate(destRoute, trigger: true)


    # if the user is authenticated but not allowed, show an error
    @listenTo @channel, 'auth:accessDenied', =>
      errTitle   = i18n.t 'Access denied'
      errMessage = i18n.t 'You are not allowed to access to this section.'

      # show a flash msg
      @channel.request 'flash:error', errMessage, errTitle,
        preventDuplicates: true

      # redirect
      @navigate(@errorRoute, trigger: true)


    # if the user was trying to access some route before
    # the unauthenticated event, redirect to that route
    @listenTo @channel, 'auth:authenticated', =>
      if prevRoute is @loginRoute
        prevRoute = null
      if prevRoute
        @navigate(prevRoute, trigger: true)
        prevRoute = null
      else
        @navigate(@rootRoute, trigger: true)
