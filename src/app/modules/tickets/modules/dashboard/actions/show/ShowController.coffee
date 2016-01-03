# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
ShowView       = require './views/ShowView'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Dashboard module, and the parent
# module channel.
ticketsChannel   = require '../../../../moduleChannel'
dashboardChannel = require '../../moduleChannel'


# Ticket stats dashboard controller
#
module.exports = class DashboardController extends ViewController

  initialize: (options) ->

    # instantitate the model
    model = @getModel()

    # create the view
    @view = @getView model

    # init the widgets when the view is rendered
    @listenTo @view, 'show', => @initWidgets model

    # render
    opts =
      loading:
        entities: model

    @show @view, opts

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    ticketsChannel.trigger 'section:changed', @getActionMetadata()



  # Widgets:
  #
  # Most charts are handled by the view, but there might be some of them
  # implemented as self contained widgets so they can be used somewhere else
  # -------------------------------------------------------------------------
  widgets: []

  initWidgets: (model) ->
    widgetOpts =
      model:  model.get 'byDate'
      region: @view.getRegion 'byDateWidgetRegion'

    widget = @appChannel.request 'widgets:tickets:byDate', widgetOpts

    if widget then @widgets.push widget



  destroy: ->
    @widgets.forEach (widget) ->
      widget.destroy()
    super()



  # Aux
  # -----------------

  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @return {View}
  ###
  getView: (model) ->
    new ShowView
      model: model


  ###
  Load the model
  ###
  getModel: ->
    @appChannel.request 'tickets:stats:entity'


  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @param  {Model}
  @return {Object}
  ###
  getActionMetadata: () ->
    meta = dashboardChannel.request 'meta'
    {
      module:
        name: meta.title()
        url: meta.rootUrl
    }
