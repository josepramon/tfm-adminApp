# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
LayoutView     = require './views/LayoutView'

# Module radio channel
headerChannel  = require '../moduleChannel'




###
Header layout controller
=========================

@class
@augments ViewController

###
module.exports = class LayoutController extends ViewController

  ###
  Controller initialization
  ###
  initialize: ->

    # Get the view
    layout = @getLayoutView()

    # Setup it
    headerChannel.reply 'region', (region) -> layout.getRegion region

    @listenTo layout, 'layout:collapse', () =>
      @appChannel.trigger 'layout:collapse'

    # Render
    @show layout



  # Aux. methods
  # -----------------

  ###
  LayoutView getter

  Instantiates the appropiate layout view

  @return {LayoutView}
  ###
  getLayoutView: ->
    new LayoutView()
