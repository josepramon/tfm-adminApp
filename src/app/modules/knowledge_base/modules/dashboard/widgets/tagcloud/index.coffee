# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
TagCloudView = require './views/TagCloudView'


module.exports = class TagCloudController extends ViewController

  initialize: (options) ->

    # get the data
    tags = @getData() ## opts to retrieve them all

    # create the view
    view = @getView tags

    # render
    @show view,
      loading:
        entities: tags


  ###
  View getter

  @param {Collection} data
  ###
  getView: (data) ->
    new TagCloudView
      collection: data


  ###
  Collection getter
  ###
  getData: ->
    @appChannel.request 'kb:tags:entities'
