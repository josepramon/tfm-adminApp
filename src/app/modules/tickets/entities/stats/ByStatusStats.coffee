# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
_         = require 'underscore'
i18n      = require 'i18next-client'
factory   = require 'msq-appbase/lib/utilities/factory'
Backbone  = require 'backbone'


module.exports = class ByStatusStatsModel extends Model

  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {Status} Status model
    ###
    status: null

    ###
    @property {Number}
    ###
    total: 0


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:           Backbone.One
      key:            'status'
      relatedModel:-> factory.invoke 'tickets:entities|Status'
  ]
