# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# Layout view
LayoutView     = require './views/LayoutView'

# Layout header
HeaderView     = require './views/HeaderView'
Model          = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there's an additional independent channel for the module
moduleChannel  = require '../moduleChannel'




###
Knowledge Base layout controller
=================================

All the controllers of this module share the same layout,
so avoid re-rendering the entire view and update only the required regions

@class
@augments ViewController

###
module.exports = class LayoutController extends ViewController

  ###
  Controller initialization
  ###
  initialize: ->
    moduleChannel.reply 'layout:get', => @getLayout()


  ###
  Layout initialization

  Returns the layout, creating it if its not already created

  @return {LayoutView}
  ###
  getLayout: ->
    if not @layout or @layout?.isDestroyed
      # create the view
      @layout = @getLayoutView()

      # init the auxiliary views
      @listenToOnce @layout, 'show', =>
        @createHeader @layout.getRegion 'header'

      # render it
      @show @layout

    @layout


  ###
  Header initialization

  @param {Marionette.Region} region  region to render the header on
  ###
  createHeader: (region) ->
    model = @getHeaderModel()
    view  = @getHeaderView model

    # setup some event handlers
    view.listenTo model, 'change', ->
      view.render()

    @listenTo moduleChannel, 'section:changed', (data) ->
      model.set(
        parentModule: data.parentModule
        module:       data.module
        action:       data.action
        item:         data.item
      ,
        # prevent multiple renders triggered by each change
        silent: true
      ).trigger 'change'

    # render
    @show view, region: region


  ###
  LayoutView getter

  Instantiates the appropiate layout
  ###
  getLayoutView: ->
    new LayoutView()


  ###
  HeaderModel getter

  Instantiates the appropiate model (currently just a plain Backbone model)
  ###
  getHeaderModel: ->
    new Model()


  ###
  HeaderView getter

  Instantiates the appropiate view

  @param {Backbone.model} model  a dummy model with some data to display on the header
  ###
  getHeaderView: (model) ->
    new HeaderView
      model: model
