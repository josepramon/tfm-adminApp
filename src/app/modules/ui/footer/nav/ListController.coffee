# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
FooterView     = require './FooterView'

# Libs/generic stuff:
Collection     = require 'msq-appbase/lib/appBaseComponents/entities/Collection'
i18n           = require 'i18next-client'


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
    new Collection @getLinks() # tmp


  ###
  @todo replace this with models
  @return {Array}
  ###
  getLinks: ->
    [
      {
        "text" : i18n.t "footer::About"
        "url"  : "#"
      }
      {
        "text" : i18n.t "footer::Support"
        "url"  : "#"
      }
      {
        "text" : i18n.t "footer::Terms of Service"
        "url"  : "#"
      }
      {
        "text" : i18n.t "footer::Legal"
        "url"  : "#"
      }
      {
        "text" : i18n.t "footer::Help"
        "url"  : "#"
      }
      {
        "text" : i18n.t "footer::Contact Us"
        "url"  : "#"
      }
    ]
