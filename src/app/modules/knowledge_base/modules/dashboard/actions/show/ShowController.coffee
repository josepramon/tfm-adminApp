# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
ShowView       = require './ShowView'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Dashboard module, and the parent
# module channel.
kbChannel        = require '../../../../moduleChannel'
dashboardChannel = require '../../moduleChannel'


# Knowledge base dashboard module controller
#
# Controller responsible for the dashboard
#
# This controller is responsible for instantiating views,
# fetching entities (models/collections) and ensuring views
# are configured properly.
#
# When those views emit evnts throughout their lifecycle or
# when something in particular happens which is important to
# the application, this controller will listen for those
# events and generally bubble those events up to the parent
# module. In this case that module whould be 'MediaApp', which
# is responsible for handling application specific events.
#
module.exports = class DashboardController extends ViewController

  initialize: (options) ->

    # Get the layout
    # All the controllers of this module share the same layout,
    # so avoid re-rendering the entire view and update only the required regions
    layout = kbChannel.request 'layout:get'

    # create the view
    @view = @getView()

    # init the widgets when the view is rendered
    @listenTo @view, 'show', => @initWidgets()

    # render
    @show @view, region: layout.getRegion 'main'

    # this module 'sections' have a shared layout with common regions
    # (the header and the items list), so after loading the section, it
    # may be necessary to update other regions
    kbChannel.trigger 'section:changed', @getActionMetadata()



  # Widgets:
  # -----------------

  widgets: []


  initWidgets: ->
    statsWidget = @appChannel.request 'widgets:kb:stats',
      region: @view.getRegion 'region1'

    tagCloudWidget = @appChannel.request 'widgets:kb:tagCloud',
      region: @view.getRegion 'region2'

    if statsWidget    then @widgets.push statsWidget
    if tagCloudWidget then @widgets.push tagCloudWidget


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
  getView: ->
    new ShowView()


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
