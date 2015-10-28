# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
ShowView       = require './views/ShowView'

# Radio channels:
# All the modules have inherited an @appChannel propperty,
# which is a global communication channel. In this case,
# there're two addittional independent channels, the
# channel for the Dashboard module, and the parent
# module (blog) channel.
moduleChannel = require '../../moduleChannel'


# Tickets module show controller
#
# This controller is responsible for instantiating views,
# fetching entities (models/collections) and ensuring views
# are configured properly.
#
# When those views emit events throughout their lifecycle or
# when something in particular happens which is important to
# the application, this controller will listen for those
# events and generally bubble those events up to the parent
# module.
#
module.exports = class ShowController extends ViewController

  initialize: (options) ->
    { model, id } = options
    model = null

    # create the view
    view = @getView model

    # render
    @show view

    # trigger a custom event (to update the title somewhere else for example)
    moduleChannel.trigger 'section:changed', @getActionMetadata()




  # Aux
  # -----------------

  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Model}
  @return {View}
  ###
  getView: (data) ->
    new ShowView
      model: data


  ###
  Action metadata getter

  When this controller gets executed, it might be necessary
  to update the UI to show the current section or something

  @param  {Model}
  @return {Object}
  ###
  getActionMetadata: () ->
    meta = moduleChannel.request 'meta'
    {
      module: meta.title
    }
