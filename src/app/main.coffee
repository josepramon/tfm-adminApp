###
Application bootstraping
==========================
###

$       = require 'jquery'
_       = require 'underscore'
Cookies = require 'js-cookie'
App     = require './AdminApp'


do ->
  # Set the default language
  # The application uses i18next to handle the locales. The library is configured
  # to use the language saved on a cookie, if not found, it tries to detect the
  # appropiate lang based on the user env., but since the user can't change the
  # language (the switcher is not enabled), it's better to use the locale determined
  # by the site owner (the one of the 'lang' attribute in the 'html' tag)
  #
  # This should be executed before everything else to avoid
  # unnecessary locale files loading
  savedLang = Cookies.get 'lang'

  if !savedLang
    pageLang = null
    htmlEl   = document.querySelector 'html'

    if htmlEl   then pageLang = htmlEl.getAttribute 'lang'
    if pageLang then Cookies.set 'lang', pageLang


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
