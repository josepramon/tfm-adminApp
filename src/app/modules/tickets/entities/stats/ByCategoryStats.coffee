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


module.exports = class ByCategoryStatsModel extends Model

  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {Category} Category model
    ###
    category: null

    ###
    @property {StatsData} Stats
    ###
    stats: null


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:           Backbone.One
      key:            'category'
      relatedModel:-> factory.invoke 'tickets:entities|Category'
    ,
      type:           Backbone.One
      key:            'stats'
      relatedModel:   StatsData
  ]
