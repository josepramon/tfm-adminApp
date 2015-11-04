# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
NavView        = require './views/NavView'

# Libs/generic stuff:
Collection     = require 'msq-appbase/lib/appBaseComponents/entities/Collection'
i18n           = require 'i18next-client'




###
Header Nav controller
======================

@class
@augments ViewController

###
module.exports = class NavController extends ViewController

  ###
  Controller initialization
  ###
  initialize: ->
    collection = @getLinksCollection(@getLinks())
    @view      = @getView collection

    # update the collection on auth events and when the user changes the language
    @listenTo @appChannel, 'auth:authenticated',   => collection.reset @getAuthenticatedLinks()
    @listenTo @appChannel, 'auth:unauthenticated', => collection.reset @getUnauthenticatedLinks()
    @listenTo @appChannel, 'locale:loaded',        => collection.reset @getLinks()

    @show @view


  # Aux
  # -----------------

  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param {Collection} links Links collection
  @return {View}
  ###
  getView: (links) ->
    new NavView
      collection: links


  ###
  Header links collection getter

  Instantiates the collection that will feed the view

  @return {Collection}
  ###
  getLinksCollection: (data) ->
    new Collection data


  ###
  @return {Array} links to display
  ###
  getLinks: ->
    if @appChannel.request 'auth:isAuthenticated'
      @getAuthenticatedLinks()
    else
      @getUnauthenticatedLinks()


  ###
  @return {Array} links to display if the user is authenticated
  ###
  getAuthenticatedLinks: ->
    [
        'label': i18n.t 'header::Logout'
        'url'  : '#user/logout'
        'icon' : 'power-off'
    ]


  ###
  @return {Array} links to display if the user is not authenticated
  ###
  getUnauthenticatedLinks: ->
    [
        'label':      i18n.t 'header::Login'
        'url'  :     '#user/login'
        'className': 'btn btn-link btn-sm'
    ]
