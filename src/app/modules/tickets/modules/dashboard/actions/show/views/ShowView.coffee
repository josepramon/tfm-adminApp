# Dependencies
# -----------------------

# Libs/generic stuff:
_      = require 'underscore'
i18n   = require 'i18next-client'
c3     = require 'c3'

# Base class
LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'


###
Tickets dashboard view
=======================

@class
@augments ItemView

###
module.exports = class DashboardView extends LayoutView
  template:  require './templates/dashboard.hbs'
  className: 'sectionContainer dashboard'
  id:        'ticketsDashboard'

  ###
  Widget regions:
  the byDate chart is not defined here because it's displayed somewhere else,
  so it's implemented as a sel contained widget to avoid repeating code
  ###
  regions:
    byDateWidgetRegion: '#stats-byDate-container'


  ui:
    'detailsContainer':      '#stats-detailed'
    'detailsResetBtn':       '#stats-detailed-reset'
    'detailsContainerTitle': '#stats-detailed-title'

  events:
    'chart:click':               'chartClickHandler'
    'click @ui.detailsResetBtn': 'resetDetailsChart'


  ###
  Charts config
  ###
  charts: require './config/charts'


  ###
  View initialization
  ###
  initialize: ->
    # Init the labels
    @labels =
      open:       i18n.t 'tickets:::stats::open'
      closed:     i18n.t 'tickets:::stats::closed'
      assigned:   i18n.t 'tickets:::stats::assigned'
      unassigned: i18n.t 'tickets:::stats::unassigned'
      min:        i18n.t 'tickets:::stats::min'
      max:        i18n.t 'tickets:::stats::max'
      average:    i18n.t 'tickets:::stats::average'
      total:      i18n.t 'tickets:::stats::total'
      name:       i18n.t 'tickets:::stats::name'
      status:     i18n.t 'tickets:::stats::status'


  ###
  Init the charts when the DOM is ready
  ###
  onShow: ->
    data = @model.toJSON()

    @drawDetailedCharts data.general
    @drawByUserChart data.byUser
    @drawByManagerChart data.byManager
    @drawByCategoryChart data.byCategory
    @drawByStatusChart data.byStatus

    # save the data as an instance attribute
    @data = data


  ###
  Destroy the charts before unloading the view
  ###
  onBeforeDestroy: ->
    _.each @charts, (chart) ->
      if chart.instance
        chart.instance.destroy()
        delete chart.instance


  ###
  Ev. hander, dispatched from the charts, redraws the DetailedCharts
  ###
  chartClickHandler: (e, params = {}) =>
    if params.data
      @drawDetailedCharts params.data, params.chart
      $('body').scrollTo '#stats-detailed'


  ###
  Ev. hander, redraws the DetailedCharts with the general data
  ###
  resetDetailsChart: -> @drawDetailedCharts @data.general


  ###
  Detailed charts (from the global stats or whatever)
  ###
  drawDetailedCharts: (data, title) ->
    labels = @labels

    @createOrUpdateChart @charts.openTickets,
      chartData:
        columns: [
          [labels.open, data.open]
          [labels.closed, data.closed]
        ]

    @createOrUpdateChart @charts.assignedTickets,
      chartData:
        columns: [
          [labels.assigned, data.assigned]
          [labels.unassigned, data.unassigned]
        ]

    @createOrUpdateChart @charts.resolutionTime,
      chartData:
        columns: [
          [labels.min, data.resolutionTime.min]
          [labels.max, data.resolutionTime.max]
          [labels.average, data.resolutionTime.average]
        ]

    # update the block
    if title
      newTitle = title
      @ui.detailsContainer.addClass 'custom'
    else
      newTitle = @ui.detailsContainerTitle.data 'originalTitle'
      @ui.detailsContainer.removeClass 'custom'

    @ui.detailsContainerTitle.text newTitle


  ###
  Draw the chart that displays the ticket stats by user
  ###
  drawByUserChart: (data) ->
    @_drawUserChart @charts.byUser, data, 'user'

  ###
  Draw the chart that displays the ticket stats by manager
  ###
  drawByManagerChart: (data) ->
    @_drawUserChart @charts.byManager, data, 'manager'

  ###
  Aux, draws the users/managers charts (they are almost identical)
  ###
  _drawUserChart: (chart, data, userKey = 'user') ->
    labels = @labels

    @createOrUpdateChart chart,
      chartData:
        json: data.map (obj) ->
          ret = {}
          ret[labels.name]   = obj[userKey]?.username
          ret[labels.open]   = obj.stats.open
          ret[labels.closed] = obj.stats.closed
          ret
        keys:
          x: labels.name
          value: [labels.open, labels.closed]
        groups: [[labels.open, labels.closed]]
        originalData: data

  ###
  Draw the chart that displays the ticket stats by category
  ###
  drawByCategoryChart: (data) ->
    labels = @labels

    @createOrUpdateChart @charts.byCategory,
      chartData:
        json: data.map (obj) ->
          ret = {}
          ret[labels.name]   = obj.category.name
          ret[labels.open]   = obj.stats.open
          ret[labels.closed] = obj.stats.closed
          ret
        keys:
          x: labels.name
          value: [labels.open, labels.closed]
        groups: [[labels.open, labels.closed]]
        originalData: data

  ###
  Draw the chart that displays the ticket stats by statys
  ###
  drawByStatusChart: (data) ->
    labels = @labels

    @createOrUpdateChart @charts.byStatus,
      chartData:
        json: data.map (obj) ->
          ret = {}
          ret[labels.status] = obj.status.name
          ret[labels.total]  = obj.total
          ret
        keys:
          x: labels.status
          value: [labels.total]



  ###
  Create a new chart (or if exists, just update it)

  @param {Object} chart  chart parameters
  @param {Object} data
  ###
  createOrUpdateChart: (chart, data) ->
    if chart.instance
      @updateChart chart, data
    else
      chart.instance = @createChart chart, data


  ###
  Create a new chart

  @param {Object} chart  chart parameters
  @param {Object} data
  ###
  createChart: (chart, data = {}) ->
    # make sure the container for the chart exists
    unless @$(chart.target).length then return

    opts =
      bindto: chart.target
      data: data.chartData
      color:
        pattern: ['#30b5e5', '#e84667', '#ccd42e', '#e55f21']

    # set the chart type
    opts.data.type = chart.type

    settings = _.deepExtend {}, opts, chart.settings(data)

    c3.generate settings


  ###
  Update an already rendered chart

  @param {Object} chart  chart parameters
  @param {Object} data
  ###
  updateChart: (chart, data = {}) ->
    newData = data.chartData
    _.deepExtend newData, _.pick(chart.settings(data), 'data')

    # clear previous data
    newData.unload = true

    chart.instance.load newData
