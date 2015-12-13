_          = require 'underscore'
$          = require 'jquery'
Marionette = require 'backbone.marionette'


module.exports = class ModalRegion extends Marionette.Region
  template: require './templates/modal.hbs'
  modalEl: null

  attachHtml: (view) ->
    options = @getDefaultOptions _.result(view, 'modal')

    if options.size is 'small' then options.sizeClassName = 'modal-sm'
    if options.size is 'large' then options.sizeClassName = 'modal-lg'

    modalWrapper = @template options

    @$el.empty().append modalWrapper
    @$el.find('.modal-body').append view.el


  onShow: (view) ->
    @setupBindings view
    options = @getDefaultOptions _.result(view, 'modal')
    @openDialog options
    @view = view


  setupBindings: (view) ->
    @listenTo view, 'modal:close', @destroy


  getDefaultOptions: (options = {}) ->
    _.defaults options,
      title: ''
      modalClass: options.className ? ''


  openDialog: (options) ->
    @$el
      .addClass('modal fade')
          .addClass(options.modalClass)
            .modal()

    @$el.on 'hidden.bs.modal', (e) => @destroy()



  onDestroy: ->
    @$el.modal 'hide'

    @$el.off 'hidden.bs.modal'
    @stopListening()

    if @view
      @view.destroy()
      @view = null

    @$el.empty().attr 'class', ''
