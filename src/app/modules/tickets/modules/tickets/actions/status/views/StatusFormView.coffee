# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'

# View behaviours
EditorBehaviour = require 'msq-appbase/lib/behaviours/Editor'


###
Ticket status form view
==========================

@class
@augments ItemView

###
module.exports = class StatusFormView extends ItemView
  template: require './templates/statusForm.hbs'

  ui:
    'statusSelect' : '#status'


  ###
  @property {Object} view behaviours config.
  ###
  behaviors:
    Editor:
      behaviorClass: EditorBehaviour


  ###
  @property {Object} form config.
  ###
  form: ->
    btnTitle = @getTitle()
    buttons:
      primaryActions:
        primary:
          text: btnTitle
          icon: 'check'


  ###
  @property {Object} modal config.
  ###
  modal: ->
    title: @getTitle()

  onModalClose: -> @$el.trigger 'hidden.bs.modal'


  initialize: (opts = {}) ->
    if opts.statusesCollection then @statusesCollection = opts.statusesCollection


  onRender: ->
    status = @model.get 'status'

    unless status
      # initialize the dropdown
      @ui.statusSelect.selectize()


  serializeData: ->
    ret = @model.toJSON()

    if @statusesCollection
      ret.statuses = @statusesCollection.invoke 'pick', 'id', 'name'

    ret


  ###
  @return {String} the appropiate title acconrding the status
  ###
  getTitle: ->
    # default title
    title = i18n.t 'tickets:::Set status'

    status = @model.get 'status'

    if status
      if status.get 'open'   then title = i18n.t 'tickets:::Reopen ticket'
      if status.get 'closed' then title = i18n.t 'tickets:::Close ticket'

    title
