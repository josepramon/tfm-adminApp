# Dependencies
# -----------------------

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'

# Base class (extends Marionette.Controller)
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# The view
ChartView = require './views/ChartView'


module.exports = class ByDateChartController extends ViewController

  initialize: (options) ->
    # get the data
    model = options.model or @getModel()

    # create the view
    view = @getView model

    @listenTo view, 'chart:timeUnit:changed', (val) =>
      @filterModelByDateUnit model, val

    # render
    @show view,
      loading:
        entities: model


  ###
  View getter

  @param {Model} data
  ###
  getView: (data) ->
    new ChartView
      model: data


  ###
  Load the model
  ###
  getModel: () ->
    @appChannel.request 'tickets:stats:byDate:entity'


  ###
  Apply a filter (by year/month/date) to the model
  ###
  filterModelByDateUnit: (model, unit) ->
    # reset the previous filter
    model.removeQueryFilter 'byDate'

    # set the new filter
    if unit
      model.addQueryFilter 'byDate', unit

    # fetch the data
    model.fetch()
