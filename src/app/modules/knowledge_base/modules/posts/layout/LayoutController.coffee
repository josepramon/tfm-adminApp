# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# Layout view
LayoutView     = require './views/LayoutView'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Posts module, and the parent
# module channel.
moduleChannel = require '../moduleChannel'
kbChannel     = require '../../../moduleChannel'




###
Knowledge Base Posts layout controller
=======================================

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
      # get the parent layout
      parentLayout = kbChannel.request 'layout:get'

      # create the view
      @layout = @getLayoutView()
      @setupLayoutListeners()

      # render it
      @show @layout,
        region: parentLayout.getRegion 'main'

    @layout


  ###
  LayoutView getter

  Instantiates the appropiate layout view

  @return {LayoutView}
  ###
  getLayoutView: ->
    new LayoutView()


  ###
  Layout listeners setup

  Sets the appropiate listeners for the layout
  ###
  setupLayoutListeners: ->
    @listenToOnce @layout, 'before:destroy', =>
      @clearLayoutListeners()
      @layout = null

    # the itemsList is always visible and should show always the articles list
    @listenTo @layout, 'before:show', (view) ->
      moduleChannel.trigger 'layout:rendered'


    # the model related to the main view may be used somewhere else
    # (like the items list). So trigger some events when loading/unloading
    # views on the main region so the related views can be updated if necessary
    mainRegion = @layout.getRegion 'main'

    @listenTo mainRegion, 'before:show', (view) ->
      moduleChannel.trigger 'load:kb:post', view.model

    @listenTo mainRegion, 'before:empty', (view) ->
      moduleChannel.trigger 'unload:kb:post', view.model

    # if the loaded model on the mainRegion is deleted somewhere else
    # (for example on the itemList), unload the region
    @listenTo moduleChannel, 'deleted:kb:post', (model) =>
      @postDeleted model


  ###
  Layout listeners teardown

  Executed before the layout is destroyed
  Removes the layout listeners
  ###
  clearLayoutListeners: ->
    mainRegion = @layout.getRegion 'main'

    @stopListening mainRegion
    @stopListening @layout
    @stopListening moduleChannel, 'deleted:kb:post'


  ###
  Handler for posts deletion

  If the model loaded on the main region is deleted somewhere
  (like on the media list), clear the main region

  @param {Article} model    the deleted article
  ####
  postDeleted: (model) ->
    if @layout
      mainRegion = @layout.getRegion('main')
      if mainRegion.currentView
        if mainRegion.currentView.model.id == model.id
          mainRegion.empty()
          moduleChannel.trigger 'done:kb:post'
