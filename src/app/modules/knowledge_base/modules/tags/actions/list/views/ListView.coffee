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

# Helper function, returns some localized attribute
localizedCellFormater = require 'msq-appbase/lib/appBaseComponents/views/grid/helpers/localizedCellFormater'


###
Knowledge Base tags module list
================================

@class
@augments CompositeView

###
module.exports = class KBTagsListView extends GridView

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
      name:      'slug'
      cell:      'string'
    ,
      name:      'articles_total'
      cell:      'integer'
    ,
      cell:        'button'
      btnLabel:    iconBtnTmpl { label: 'edit', icon: 'edit' }
      buttonClass: 'btn btn-link'
      clickEvent:  'editTag'
    ,
      cell:        'button'
      btnLabel:    iconBtnTmpl { label: 'delete', icon: 'times' }
      buttonClass: 'btn btn-link'
      clickEvent:  'deleteTag'
  ]

  gridCssClasses: ['table', 'table-striped', 'table-bordered', 'filled']


  ###
  @property {Boolean} Don't render the grid if there are no tags
                      (it will be handled by the template)
  ###
  renderGridWithEmptyCollection: false


  ###
  @property {Object} event handlers for UI elements
  ###
  events:
    'editTag':       'editTag'
    'deleteTag':     'deleteTag'

  triggers:
    'click .newTag': 'create:kb:tag'



  # Handlers
  # --------------------

  editTag: (ev, args) ->
    @triggerMethod 'edit:kb:tag', args

  deleteTag: (ev, args) ->
    if window.confirm(i18n.t 'Are you sure you want to delete this?')
      @triggerMethod 'delete:kb:tag', args
