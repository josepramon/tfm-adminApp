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


###
Tickets list
==============

@class
@augments GridView

###
module.exports = class CategoriesListView extends GridView

  template: require './templates/list.hbs'

  id: 'ticketsList'

  regions:
    grid:       '.grid'
    pagination: '.gridPagination'
    filter:     '.gridFilter'

  gridCssClasses: ['table', 'table-striped', 'table-bordered', 'filled']


  ###
  View initialization
  ###
  initialize: (options = {}) ->
    lang = @appChannel.request 'locale:get'
    statusLabel = i18n.t 'tickets:::TicketModel::Status'

    @columns = [
        name: 'id'
        cell: 'html'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            label = rawValue
            link  = '#tickets/' + label
            "<a href='#{link}'><code class='ticketCode'>#{label}</code></a>"
      ,
        name: 'title'
        cell: 'html'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            label = _s(rawValue).truncate(80).value()
            link  = '#tickets/' + model.get('id')
            "<a href='#{link}'>#{label}</a>"
      ,
        name: 'category'
        cell: 'string'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            if rawValue
              rawValue.get 'name'
            else
              ''
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
        cell: 'string'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            if rawValue
              rawValue.get 'username'
            else
              ''
      ,
        name: 'tags'
        cell: 'html'
        formatter: _.extend {}, Backgrid.CellFormatter.prototype,
          fromRaw: (rawValue, model) ->
            if rawValue
              labels = rawValue.pluck 'name'
              labels = labels.map (label) ->
                "<span class='label label-info'>#{label}</span>"
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

    @listenTo collection, 'sync:start', => @_toggleFilterBtns false
    @listenTo collection, 'sync:stop',  =>
      @_toggleFilterBtns true
      @_toggleGrid()

    super arguments


  # ---- filters setup ---

  filterTemplate: require './templates/filter.hbs'

  ui:
    statusFilterBtns:  '#ticketsNav .byStatus button'
    managerFilterBtns: '#ticketsNav .byManager button'

    gridContainer: '#ticketsGridContainer'
    noData:        '#ticketsNodataContainer'

  events:
    'click @ui.statusFilterBtns':  '_handleStatusFilterClick'
    'click @ui.managerFilterBtns': '_handleManagerFilterClick'


  _toggleGrid: =>
    if @ui.gridContainer instanceof $
      if @collection.models.length > 0
        @ui.gridContainer.show()
        @ui.noData.hide()
      else
        @ui.gridContainer.hide()
        @ui.noData.show()


  ###
  On render ev. handler
  ###
  onRender: ->
    @_createFilters()
    @_toggleGrid()


  ###
  Filters creation
  ###
  _createFilters: ->
    filter = new Filter
      collection:  @collection
      template:    @filterTemplate
      name:        'search'
      placeholder: i18n.t 'tickets:::Search tickets'

    @listenToOnce filter, 'show', =>
      # rebind UI elements
      @unbindUIElements()
      @bindUIElements()

    filterRegion = @getRegion 'filter'
    filterRegion.show filter


  ###
  Status filter buttons click handler
  ###
  _handleStatusFilterClick: (e) ->
    selectedBtn = $ e.currentTarget

    # update the ui
    @ui.statusFilterBtns.removeClass 'active'
    selectedBtn.addClass 'active'

    # bubble up the event
    filterValue = selectedBtn.data('filter') isnt 'open'
    @triggerMethod 'filterByStatus', filterValue


  ###
  Manager filter buttons click handler
  ###
  _handleManagerFilterClick: (e) ->
    selectedBtn = $ e.currentTarget

    # update the ui
    @ui.managerFilterBtns.removeClass 'active'
    selectedBtn.addClass 'active'

    # bubble up the event
    filterValue = selectedBtn.data('filter') is 'assigned'
    @triggerMethod 'filterByAssignedManager', filterValue


  ###
  Filter buttons lock/unlock
  ###
  _toggleFilterBtns: (enable) ->
    if @ui.filterBtns instanceof $
      if enable
        @ui.filterBtns.removeAttr 'disabled'
      else
        @ui.filterBtns.attr 'disabled', 'disabled'
