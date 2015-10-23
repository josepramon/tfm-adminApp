###
Application bootstraping
==========================
###

$   = require 'jquery'
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
  app = new App opts

  # Wait for the locales to be loaded before starting it
  app.channel.once 'locales:loaded', ->
    app.start()

  # the global Mosaiqo var is just for debugging purposes and will be removed
  window.Mosaiqo = app
