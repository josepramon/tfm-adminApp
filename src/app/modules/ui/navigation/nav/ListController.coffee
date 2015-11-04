# Dependencies
# -----------------------

# Base class (extends Marionette.Module)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
NavView        = require './NavView'

# Other required stuff
Collection     = require 'msq-appbase/lib/appBaseComponents/entities/Collection'
Backbone       = require 'backbone'




###
Nav. module show controller
============================

@class
@augments ViewController

###
module.exports = class ListController extends ViewController

  ###
  Controller initialization
  ###
  initialize: ->
    navLinks = @getLinksCollection()
    @view    = @getView navLinks
    @show @view

    @listenTo Backbone.history, 'route', ->
      url = Backbone.history.getFragment()
      url = url.replace(/\/\d+.*$/, '').replace(/\/new\/?$/, '')
      @view.setActiveItem url


    # refresh if the user changes the language
    @listenTo @appChannel, 'locale:loaded', =>
      @view.collection = @getLinksCollection()
      @view.render()


  ###
  Controller destroy method
  ###
  destroy: ->
    @view.destroy()
    super


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
    new NavView
      collection: data


  ###
  Navigation links collection getter

  Instantiates the collection that will feed the view

  @return {Collection}
  ###
  getLinksCollection: ->
    navItems = @appChannel.request 'app:navigation'
    new Collection navItems
