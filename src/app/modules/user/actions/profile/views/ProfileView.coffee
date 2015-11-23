# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'



###
Profile edit view
=======================

@class
@augments ItemView

###
module.exports = class ProfileView extends ItemView
  template: require './templates/profile.hbs'

  ###
  @property {Object} form config.
  ###
  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Save'
          icon: 'check'


  ###
  Handler executed when the view is rendered
  ###
  onRender: ->
    @setupUploader()


  ###
  Attachments uploader initialization
  ###
  setupUploader: ->
    _this = @

    # uploader settings
    opts =
      addRemoveLinks:  true
      deleteOnReplace: true

      # override the serialization methods
      serialize: _this.serializeUpload

    # preexisting profile image
    imageField  = @$('#profileImage')
    profile     = @model.get 'profile'
    customImage = []
    if profile
      image = profile.get 'image'
      if image then customImage = [image.toJSON()]

    # instantiate the uploader
    uploader = @appChannel.request 'uploader:component', imageField, opts, customImage

    avatarImage = imageField.data 'avatar'

    if avatarImage
      @$('.profileImageContainer .dropzone').css 'background-image', "url(#{avatarImage})"


  ###
  Uploader component serialize method override
  ###
  serializeUpload: (file) ->
    # file.uploadModel?.get 'id'
    JSON.stringify file.uploadModel?.toJSON()
