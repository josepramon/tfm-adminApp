# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'
_        = require 'underscore'
_s       = require 'underscore.string'
Backgrid = require 'backgrid'

# Base class (extends Marionette.LayoutView)
GridView    = require 'msq-appbase/lib/appBaseComponents/views/grid/GridView'

# Template used to display icon buttons
iconBtnTmpl = require 'views/widgets/templates/iconBtn.hbs'


###
Knowledge Base statuses module list
======================================

@class
@augments CompositeView

###
module.exports = class CategoriesListView extends GridView

  template:  require './templates/list.hbs'
  className: 'sectionContainer'

  regions:
    grid:       '.grid'
    pagination: '.gridPagination'


  columns: [
      name:      'name'
      cell:      'string'
    ,
      name:      'description'
      cell:      'string'
      formatter: _.extend {}, Backgrid.CellFormatter.prototype,
        fromRaw: (rawValue, model) ->
          _s(rawValue).stripTags().truncate(20).value()
    ,
      cell:        'button'
      btnLabel:    iconBtnTmpl { label: 'edit', icon: 'edit' }
      buttonClass: 'btn btn-link'
      clickEvent:  'editStatus'
    ,
      cell:        'button'
      btnLabel:    iconBtnTmpl { label: 'delete', icon: 'times' }
      buttonClass: 'btn btn-link'
      clickEvent:  'deleteStatus'
  ]

  gridCssClasses: ['table', 'table-striped', 'table-bordered', 'filled']


  ###
  @property {Boolean} Don't render the grid if there are no statuses
                      (the template will show something else)
  ###
  renderGridWithEmptyCollection: false


  ###
  @property {Object} event handlers for UI elements
  ###
  events:
    'editStatus':   'editStatus'
    'deleteStatus': 'deleteStatus'

  triggers:
    'click .newStatus': 'create:tickets:status'



  # Handlers
  # --------------------

  editStatus: (ev, args) ->
    @triggerMethod 'edit:tickets:status', args

  deleteStatus: (ev, args = {}) ->
    if args.model
      deleteable = args.model.get 'deleteable'

      if deleteable
        if window.confirm(i18n.t 'Are you sure you want to delete this?')
          @triggerMethod 'delete:tickets:status', args
      else
        window.alert(i18n.t 'tickets:::This is a default status and cannot be deleted')

  showRelatedArticles: (ev, args) ->
    @triggerMethod 'showArticles:tickets:status', args
