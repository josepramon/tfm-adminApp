Backbone    = require 'backbone'
Model       = require 'msq-appbase/lib/appBaseComponents/entities/Model'
UploadModel = require './Upload'


module.exports = class FileAttachmentModel extends Model

  ###
  @property {Object} Model default attributes
  ###
  defaults:
    upload: null


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:         Backbone.One
      key:          'upload'
      relatedModel: UploadModel
  ]
