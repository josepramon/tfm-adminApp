# Dependencies
# -----------------------

# Libs/generic stuff:
_          = require 'underscore'
i18n       = require 'i18next-client'
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
FooterView = require './FooterView'


###
Footer module show controller
===============================

@class
@augments ViewController

###
module.exports = class ListController extends ViewController

  ###
  Controller initialization
  ###
  initialize: ->
    footerLinks = @getLinksCollection()
    view        = @getView footerLinks

    @show view

    # refresh if the user changes the language
    @listenTo @appChannel, 'locale:loaded', =>
      footerLinks.reset @getLinks()


  # Aux
  # -----------------

  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Collection}
  @return {View}
  ###
  getView: (data) ->
    new FooterView
      collection: data


  ###
  Footer links collection getter

  Instantiates the collection that will feed the view

  @return {Collection}
  ###
  getLinksCollection: ->
    new Collection @getLinks()


  ###
  @return {Array}
  ###
  getLinks: ->
    if process.env.CUSTOM_FOOTER
      if _.isArray process.env.CUSTOM_FOOTER
        process.env.CUSTOM_FOOTER
      else
        []
