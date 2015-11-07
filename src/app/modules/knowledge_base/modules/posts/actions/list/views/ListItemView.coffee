# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'




###
Knowledge Base posts module list item
======================================

@class
@augments ItemView

###
module.exports = class ListItemView extends ItemView

  template: require './templates/listItem.hbs'
  tagName : 'li'

  ###
  @property {Object} DOM elements
  ###
  ui:
    itemEditBtn:   '.itemEdit'
    itemDeleteBtn: '.itemDelete'
    itemActiveBtn: '.itemActive'


  ###
  @property {Object} View triggers
  ###
  triggers:
    'click @ui.itemEditBtn':   'edit:kb:post'
    'click @ui.itemActiveBtn': 'toggleActive:kb:post'


  ###
  @property {Object} event handlers for UI elements
  ###
  events:
    'click @ui.itemDeleteBtn': 'handlePostDelete'


  ###
  @property {Object} model events
  ###
  modelEvents:
    'change': 'render'


  # Handlers
  # --------------------

  onRender: ->
    if !@model.get 'published'
      @$el.addClass 'inactive'
    else
      @$el.removeClass 'inactive'

  highlightElement: ->
    @$el.addClass 'active'

  unhighlightElement: ->
    @$el.removeClass 'active'

  handlePostDelete: =>
    if window.confirm(i18n.t 'Are you sure you want to delete this?')
      @triggerMethod 'delete:kb:post',
        model: @model
