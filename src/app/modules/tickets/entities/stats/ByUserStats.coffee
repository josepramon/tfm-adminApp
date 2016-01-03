# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
_         = require 'underscore'
i18n      = require 'i18next-client'
factory   = require 'msq-appbase/lib/utilities/factory'
Backbone  = require 'backbone'

StatsData = require './StatsData'


module.exports = class ByUserStatsModel extends Model

  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {User} User model
    ###
    user: null

    ###
    @property {StatsData} Stats
    ###
    stats: null


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:           Backbone.One
      key:            'user'
      relatedModel:-> factory.invoke 'user:entities|User'
    ,
      type:           Backbone.One
      key:            'stats'
      relatedModel:   StatsData
  ]
