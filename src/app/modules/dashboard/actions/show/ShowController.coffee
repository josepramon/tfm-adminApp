# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
ShowView = require './views/ShowView'


# Dashboard controller
#
module.exports = class DashboardController extends ViewController

  initialize: (options) ->
    # create the view
    @view = @getView()

    # init the widgets when the view is rendered
    @listenTo @view, 'show', => @initWidgets()

    # render
    @show @view



  # Widgets:
  # -----------------
  widgets: []


  initWidgets: () ->
    ticketsWidget = @appChannel.request 'widgets:tickets:byDate',
      region: @view.getRegion 'ticketsWidgetRegion'

    kbWidget = @appChannel.request 'widgets:kb:stats',
      region: @view.getRegion 'kbWidgetRegion'

    usersWidget = @appChannel.request 'widgets:users:stats',
      region: @view.getRegion 'usersWidgetRegion'

    if ticketsWidget then @widgets.push ticketsWidget
    if kbWidget      then @widgets.push kbWidget
    if usersWidget   then @widgets.push usersWidget


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
  getView: () ->
    new ShowView()
