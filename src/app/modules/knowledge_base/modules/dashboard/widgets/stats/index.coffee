# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
StatsView = require './views/StatsView'


module.exports = class StatsController extends ViewController

  initialize: (options) ->

    # get the data
    collection = new Collection()
    entitites    = @getStats collection

    # create the view
    view = @getView collection

    # render
    @show view,
      loading:
        entities: entitites


  ###
  View getter

  @param {Collection} data
  ###
  getView: (data) ->
    new StatsView
      collection: data


  ###
  Stats initialization

  Currently only the totals

  @param  {Collection} collection  Backbone collection to update with the parsed data
  @return {Array}      requested data, this may be used to delay the view rendering
  ###
  getStats: (collection) ->
    articles   = @appChannel.request 'kb:articles:entities'
    categories = @appChannel.request 'kb:categories:entities'

    @appChannel.request 'when:fetched', [articles, categories], ->
      collection.add
        label: i18n.t 'kb:::sections::Posts'
        value: if articles.state then articles.state.totalRecords else articles.models.length
        href:  '#knowledge-base/posts'

      collection.add
        label: i18n.t 'kb:::sections::Categories'
        value: if categories.state then categories.state.totalRecords else categories.models.length
        href:  '#knowledge-base/categories'

    [articles, categories]
