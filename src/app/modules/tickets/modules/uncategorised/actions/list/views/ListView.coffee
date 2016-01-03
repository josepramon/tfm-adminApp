# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'
_        = require 'underscore'
_s       = require 'underscore.string'
moment   = require 'moment'
Backgrid = require 'backgrid'
Filter   = require 'msq-appbase/lib/appBaseComponents/views/grid/CustomServerSideFilter'

# Base class (extends Marionette.LayoutView)
GridView = require 'msq-appbase/lib/appBaseComponents/views/grid/GridView'

# Radio channels:
ticketsChannel = require '../../../../../moduleChannel'
moduleChannel  = require '../../../moduleChannel'

###
Tickets list
==============

@class
@augments GridView

###
module.exports = class CategoriesListView extends GridView
  template: require './templates/list.hbs'

  className: 'sectionContainer'

  id: 'ticketsList'

  regions:
    grid:       '.grid'
    pagination: '.gridPagination'

  gridCssClasses: ['table', 'table-striped', 'table-bordered', 'filled']

  renderGridWithEmptyCollection: false


  ###
  View initialization
  ###
  initialize: (options = {}) ->
    lang = @appChannel.request 'locale:get'
    statusLabel = i18n.t 'tickets:::TicketModel::Status'
    baseUrl = '#' + moduleChannel.request('meta').rootUrl

    @columns = [
        name: 'id'
        cell: 'html'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            label = rawValue
            link  = "#{baseUrl}/#{label}"
            "<a href='#{link}'><code class='ticketCode'>#{label}</code></a>"
      ,
        name: 'title'
        cell: 'html'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            label    = _s(rawValue).truncate(80).value()
            ticketId = model.get 'id'
            link     = "#{baseUrl}/#{ticketId}"
            "<a href='#{link}'>#{label}</a>"
      ,
        name: 'priority'
        cell: 'html'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            label = '-'
            className = ''
            if rawValue
              switch rawValue
                when 1 then label = i18n.t 'tickets:::priorities::low'
                when 2
                  label = i18n.t 'tickets:::priorities::normal'
                  className = 'label-info'
                when 3
                  label = i18n.t 'tickets:::priorities::hight'
                  className = 'label-warning'
                when 4
                  label = i18n.t 'tickets:::priorities::critical'
                  className = 'label-danger'

            "<span class='label #{className}'>#{label}</span>"
      ,
        label: statusLabel
        name: 'statuses'
        cell: 'html'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            status = null
            if rawValue.models.length
              current = _.last rawValue.models
              if current then status = current.get 'status'

            if status
              val = status.get 'name'
              if status.get 'open'
                className = ''
              else if status.get 'closed'
                className = 'label-danger'
              else
                className = 'label-info'

              "<span class='label #{className}'>#{val}</span>"
            else
              ''
      ,
        name: 'user'
        cell: 'html'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            u = rawValue.toJSON()
            img = u.profile?.image?.url or u.profile?.avatar
            """
            <span class="label image user">
              <img src="#{img}" alt="" />
              #{u.username}
            </span>
            """
      ,
        name: 'tags'
        cell: 'html'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            if rawValue
              labels = rawValue.pluck 'name'
              labels = labels.map (label) ->
                "<span class='label label-info tag'>#{label}</span>"
              labels.join ' '
            else
              ''
      ,
        name: 'updated_at'
        cell: 'string'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            moment(rawValue).locale(lang).fromNow()
    ]

    { collection } = options
    super arguments
