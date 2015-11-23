###
Application bootstraping
==========================
###

$   = require 'jquery'
_   = require 'underscore'
App = require './AdminApp'

$ ->
  # App options
  opts = {}

  # Environment variables
  if window.MOSAIQO_ENV?
    opts.environment = MOSAIQO_ENV

  if window.MOSAIQO_API_ROOT_URL?
    opts.apiRootUrl = MOSAIQO_API_ROOT_URL

  # application modules
  opts.modules = require 'config/modules'

  # Instantiate and init the app
  setup = ->
    app = new App opts

    # Wait for the locales to be loaded before starting it
    app.channel.once 'locales:loaded', ->
      app.start()

    # the global Mosaiqo var is just for debugging purposes and will be removed
    window.Mosaiqo or= {}
    window.Mosaiqo.AdminsApp = app


  # Session data is implemented using sessionStorage,
  # which is sandboxed to the current tab. This enables
  # session sharing between tabs/windows
  # This must be executed before anything else
  multiWindowSession = require 'msq-appbase/lib/utilities/multiTabSessions'

  multiWindowSession.initialize _.once(setup)
