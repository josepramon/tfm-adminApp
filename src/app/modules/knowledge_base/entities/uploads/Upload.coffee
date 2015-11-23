Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'


module.exports = class UploadModel extends Model

  ###
  @property {String} Default upload API url
  ###
  urlRoot: '/api/uploads'
