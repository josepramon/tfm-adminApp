# Dependencies
# -----------------------

# Libs/generic stuff:
_      = require 'underscore'
i18n   = require 'i18next-client'
c3     = require 'c3'
moment = require 'moment'

# Base class
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Tickets by date widget view
=============================

@class
@augments ItemView

###
module.exports = class ByDateWidgetView extends ItemView
  template:  require './templates/chart.hbs'

  ###
  @property {String} current chart unit
  ###
  unit: 'day'

  ###
  Chart config
  ###
  chart:
    target: '#chart-byDate'


  ###
  @property {Object} DOM elements
  ###
  ui:
    timeUnitSelector: '[name=stats-byDate]'


  ###
  @property {Object} Dom events
  ###
  events:
    'change @ui.timeUnitSelector': 'onTimeUnitChange'


  ###
  @property {Object} model events
  ###
  modelEvents:
    'change': 'renderChart'


  ###
  View initialization
  ###
  initialize: ->
    # Init the labels
    @labels =
      created:  i18n.t 'tickets:::stats::created'
      closed:   i18n.t 'tickets:::stats::closed'
      reopened: i18n.t 'tickets:::stats::reopened'


  ###
  Destroy the chart before unloading the view
  ###
  onBeforeDestroy: ->
    if @chart.instance
      @chart.instance.destroy()
      delete @chart.instance


  ###
  Init the charts when the DOM is ready
  ###
  onShow: -> @renderChart()


  ###
  Ev. handler for the time unit selector
  ###
  onTimeUnitChange: ->
    @unit = @ui.timeUnitSelector.filter(':checked').val()
    @triggerMethod 'chart:timeUnit:changed', @unit


  ###
  Render the chart
  ###
  renderChart: ->
    data = @parseData()
    @createChart data


  ###
  Transform the data to something that can be used by the charting lib.
  ###
  parseData: ->
    labels = @labels

    # internal aux. funct.
    parseGroup = (memo, p) ->
      k = p[0]
      v = p[1]
      parsedGroup = _.map v, (v) ->
        parsedVal = _.chain(v).pairs().flatten().value()
        ret = {}
        ret.date = parsedVal[0]
        ret[k]   = parsedVal[1]
        ret
      memo.concat parsedGroup


    # parse the data
    _.chain @model.toJSON()
      .pairs()

      # parse the group
      .reduce parseGroup, []

      # merge by date
      .groupBy 'date'
      .map (group) ->
        # merge
        f = (memo, o) -> _.extend memo, o
        merged = _.reduce(group, f, {})

        # fill any missing values
        defaults = {created: 0, closed: 0, reopened: 0}
        _.defaults merged, defaults

      # translate the keys
      .map (o) ->
        f = (memo, v, k) ->
          k = labels[k] || k
          memo[k] = v
          memo
        _.reduce o, f, {}

      # the dates might be incomplete (for example they may contain only the year)
      # so convert them to full dates (otherwise, C3 will fail)
      .map (o) ->
        d = o.date.split '-'
        unless d[1] then d[1] = '01'
        unless d[2] then d[2] = '01'
        o.date = d.join '-'
        o

      .value()


  ###
  Create or update the chart
  ###
  createChart: (data) ->
    # make sure the container for the chart exists
    unless @$(@chart.target).length then return

    dataNode = @_getChartDataNode data
    dateFormatter = @_dateFormat

    if @chart.instance
      @chart.instance.load dataNode

    else
      target = @chart.target

      @chart.instance = c3.generate
        bindto: target
        color:
          pattern: ['#30b5e5', '#e84667', '#ccd42e', '#e55f21']
        data: dataNode
        axis:
          x:
            type: 'timeseries'
            tick:
              format: dateFormatter


  ###
  Aux. chart data node formatter
  ###
  _getChartDataNode: (data) ->
    labels = @labels

    {
      json: data
      type: 'spline'
      x: 'date'
      keys:
        x: 'date'
        value: [labels.created, labels.closed, labels.reopened]
      unload: true
    }


  ###
  Aux. chart date formatter
  ###
  _dateFormat: (x) =>
    lang = @appChannel.request 'locale:get'

    switch @unit
      when 'year'  then dateFormat = 'YYYY'
      when 'month' then dateFormat = 'MMMM (YYYY)'
      else dateFormat = 'L'

    moment(x).locale(lang).format dateFormat
