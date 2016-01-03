# Dependencies
# -----------------------

# Libs/generic stuff:
$      = require 'jquery'
_      = require 'underscore'
i18n   = require 'i18next-client'
moment = require 'moment'
Object = require 'msq-appbase/lib/appBaseComponents/Object'


class ChartUtil extends Object

  ###
  Aux method, for the users and managers charts
  (they're identical, so avoid repeating code)
  ###
  userChartClickHandler: (d, element, data, chartTitle = '', key = 'user') ->
    itemData = data?.chartData?.originalData?[d.index]

    title = chartTitle

    userInfo = itemData[key]

    if userInfo
      title += " - #{userInfo.username}"

      profile = userInfo.profile

      if profile
        completeName = _.compact([profile.name, profile.surname]).join ' '
        if completeName then title += " (#{completeName})"


    if itemData
      $(element).trigger 'chart:click',
        data:  itemData.stats
        chart: title


  ###
  Localised time formatter
  ###
  formatTime: (time) ->
    lang = @appChannel.request 'locale:get'
    moment.duration(time).locale(lang).humanize()


cu = new ChartUtil()


###
Charts config
###
module.exports =

  openTickets:
    target:   '#chart-byClosedStatus'
    type:     'donut'
    settings: (data) ->
      donut:
        title: i18n.t 'tickets:::stats::Open tickets'
        label:
          format: (value, ratio, id) -> value


  assignedTickets:
    target:   '#chart-byAssignedStatus'
    type:     'donut'
    settings: (data) ->
      donut:
        title: i18n.t 'tickets:::stats::Assigned tickets'
        label:
          format: (value, ratio, id) -> value


  resolutionTime:
    target: '#chart-byResolutionTime'
    type:   'bar'
    settings: (data) ->
      tooltip:
        format:
          title: (d) -> i18n.t 'tickets:::stats::Ticket resolution times'
          value: (value, ratio, id) -> cu.formatTime value
      axis:
        x:
          show: false
        y:
          show: false


  byManager:
    target: '#chart-byManager'
    type:   'bar'
    settings: (data) ->
      data:
        onclick: (d, element) ->
          chartTitle = i18n.t 'tickets:::stats::By manager'
          cu.userChartClickHandler d, element, data, chartTitle, 'manager'
      axis:
        x:
          type: 'category'

      # disable the tooltip in order to make the click work on IOS
      # @see https://github.com/masayuki0812/c3/issues/687
      tooltip:
        show: false


  byUser:
    target: '#chart-byUser'
    type:   'bar'
    settings: (data) ->
      ret =
        data:
          onclick: (d, element) ->
            chartTitle = i18n.t 'tickets:::stats::By user'
            cu.userChartClickHandler d, element, data, chartTitle, 'user'
        axis:
          x:
            type: 'category'

        # disable the tooltip in order to make the click work on IOS
        # @see https://github.com/masayuki0812/c3/issues/687
        tooltip:
          show: false

      # if there are a lot of users,
      # the graph labels become unreadable
      if data?.chartData?.originalData?.length > 50
        ret.axis.x.show = false

      ret


  byCategory:
    target: '#chart-byCategory'
    type:   'bar'
    settings: (data) ->
      data:
        onclick: (d, element) ->
          chartTitle = i18n.t 'tickets:::stats::By category'
          itemData   = data?.chartData?.originalData?[d.index]

          if itemData
            $(element).trigger 'chart:click',
              data:  itemData.stats
              chart: chartTitle + ' - ' + itemData.category?.name
      axis:
        x:
          type: 'category'


  byStatus:
    target: '#chart-byStatus'
    type:   'bar'
    settings: (data) ->
      data:
        labels: false
      axis:
        x:
          type: 'category'
