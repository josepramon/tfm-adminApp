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
Knowledge Base categories module list
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
      name:      'managers'
      cell:      'html'
      formatter: _.extend {}, Backgrid.CellFormatter.prototype,
        fromRaw: (rawValue, model) ->

          managers = rawValue?.toJSON().map (u) ->
            img = u.profile?.image?.url or u.profile?.avatar
            """
            <a class="label image manager" href="#managers/#{u.id}/edit">
              <img src="#{img}" alt="" />
              #{u.username}
              <span class="detail">#{u.email}</span>
            </a>
            """
          (managers or []).join '<br />'
    ,
      cell:        'button'
      btnLabel:    iconBtnTmpl { label: 'edit', icon: 'edit' }
      buttonClass: 'btn btn-link'
      clickEvent:  'editCategory'
    ,
      cell:        'button'
      btnLabel:    iconBtnTmpl { label: 'delete', icon: 'times' }
      buttonClass: 'btn btn-link'
      clickEvent:  'deleteCategory'
  ]

  gridCssClasses: ['table', 'table-striped', 'table-bordered', 'filled']


  ###
  @property {Boolean} Don't render the grid if there are no categories
                      (it will be handled by the template)
  ###
  renderGridWithEmptyCollection: false


  ###
  @property {Object} event handlers for UI elements
  ###
  events:
    'editCategory':        'editCategory'
    'deleteCategory':      'deleteCategory'
    'showRelatedArticles': 'showRelatedArticles'

  triggers:
    'click .newCategory': 'create:tickets:category'



  # Handlers
  # --------------------

  editCategory: (ev, args) ->
    @triggerMethod 'edit:tickets:category', args

  deleteCategory: (ev, args) ->
    if window.confirm(i18n.t 'Are you sure you want to delete this?')
      @triggerMethod 'delete:tickets:category', args

  showRelatedArticles: (ev, args) ->
    @triggerMethod 'showArticles:tickets:category', args
