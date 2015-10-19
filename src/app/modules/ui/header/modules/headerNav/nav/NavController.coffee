# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
NavView        = require './NavView'




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
    @view = @getView()

    @listenTo @view, 'nav:logout', () => @appChannel.request 'auth:logout'
    @listenTo @view, 'nav:help', ()   -> window.alert 'HELP!!!'

    # refresh if the user changes the language
    @listenTo @appChannel, 'locale:loaded', =>
      @view.render()

    @show @view


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

  @return {View}
  ###
  getView: () ->
    new NavView()
