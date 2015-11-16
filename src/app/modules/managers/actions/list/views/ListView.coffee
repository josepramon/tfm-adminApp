# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'
_        = require 'underscore'
Backgrid = require 'backgrid'

# Base class (extends Marionette.LayoutView)
GridView    = require 'msq-appbase/lib/appBaseComponents/views/grid/GridView'

# Template used to display icon buttons
iconBtnTmpl = require 'views/widgets/templates/iconBtn.hbs'




###
Managers module list
============================

@class
@augments GridView

###
module.exports = class ManagersListView extends GridView

  template:  require './templates/list.hbs'
  className: 'sectionContainer'

  regions:
    grid:       '.grid'
    pagination: '.gridPagination'

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
    'editManager':       'editManager'
    'deleteManager':     'deleteManager'

  triggers:
    'click .newManager': 'create:manager'



  initialize: ->
    lang = @appChannel.request 'locale:get'

    @columns = [
        name:      'username'
        cell:      'string'
      ,
        name:      'email'
        cell:      'string'
      ,
        name:      'created_at'
        cell:      Backgrid.Extension.MomentCell.extend
          modelInUnixOffset: true
          displayFormat:     'LL'
          displayLang:       lang
      ,
        cell:        'button'
        btnLabel:    iconBtnTmpl { label: 'edit', icon: 'edit' }
        buttonClass: 'btn btn-link'
        clickEvent:  'editManager'
      ,
        cell:        'button'
        btnLabel:    iconBtnTmpl { label: 'delete', icon: 'times' }
        buttonClass: 'btn btn-link'
        clickEvent:  'deleteManager'
    ]
    super arguments



  # Handlers
  # --------------------

  editManager: (ev, args) ->
    @triggerMethod 'edit:manager', args

  deleteManager: (ev, args) ->
    if window.confirm(i18n.t 'Are you sure you want to delete this?')
      @triggerMethod 'delete:manager', args
