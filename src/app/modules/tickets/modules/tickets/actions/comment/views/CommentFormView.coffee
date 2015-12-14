# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'

# View behaviours
EditorBehaviour = require 'msq-appbase/lib/behaviours/Editor'


###
Ticket comment form view
==========================

@class
@augments ItemView

###
module.exports = class CommentFormView extends ItemView
  template: require './templates/commentForm.hbs'

  ###
  @property {Object} form config.
  ###
  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Create'
          icon: 'check'


  ###
  @property {Object} modal config.
  ###
  modal: ->
    title: i18n.t 'tickets:::New comment'
    size: 'large'

  onModalClose: -> @$el.trigger 'hidden.bs.modal'


  ###
  @property {Object} view behaviours config.
  ###
  behaviors:
    Editor:
      behaviorClass: EditorBehaviour


  # Uploader related methods

  onRender: -> @setupUploader()

  ###
  Template used in the attachment editing modal
  ###
  modalTmpl: require './templates/attachmentsModal.hbs'


  ###
  Attachments uploader initialization
  ###
  setupUploader: ->
    _this = @

    # uploader settings
    opts =
      addRemoveLinks: true
      clickedfile: _this.handleUploadClick

      # override the serialitarion methods
      serialize:   _this.serializeUpload
      deserialize: _this.deserializeUpload

    # instantiate the uploader
    uploader = @appChannel.request 'uploader:component', @$('#attachments'), opts, []


  ###
  Click handler for the files

  Opens a modal with a form to set th attachment metadata
  ###
  handleUploadClick: (file) =>
    form = $(@modalTmpl(file))
    form.on 'submit', -> false

    @appChannel.request 'dialogs:confirm', form, (result) ->
      if result
        data = form.serializeArray()
        data.forEach (param) -> file.set param.name, param.value


  ###
  Uploader component serialize method override
  ###
  serializeUpload: (file) ->
    ret =
      name:        file.customName or file.name
      description: file.description
      upload:      file.uploadModel?.toJSON()


  ###
  Uploader component deserialize method override
  ###
  deserializeUpload: (obj) ->
    name:   obj.name
    size:   obj.upload?.size,
    type:   obj.upload?.contentType
    url:    obj.upload?.url
    upload: obj.upload
