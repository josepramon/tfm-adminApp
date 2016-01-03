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
    users    = @appChannel.request 'users:entities'
    managers = @appChannel.request 'managers:entities'

    @appChannel.request 'when:fetched', [users, managers], ->
      collection.add
        label: i18n.t 'managers:::sections::Users'
        value: if users.state then users.state.totalRecords else users.models.length

      collection.add
        label: i18n.t 'managers:::sections::Managers'
        value: if managers.state then managers.state.totalRecords else managers.models.length

    [users, managers]
