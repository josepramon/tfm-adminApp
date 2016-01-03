# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
_        = require 'underscore'
i18n     = require 'i18next-client'
Backbone = require 'backbone'

# Related entities
StatsData       = require './StatsData'
ByUserStats     = require './ByUserStats'
ByCategoryStats = require './ByCategoryStats'
ByStatusStats   = require './ByStatusStats'
ByDateStats     = require './ByDateStats'



###
Ticket stats model
===================

@class
@augments Model

###
module.exports = class StatsModel extends Model

  ###
  @property {String} API url
  ###
  url: '/api/tickets/stats'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {StatsData} Global stats
    ###
    general: null

    ###
    @property {ByUserStats[]} Stats by user
    ###
    byUser: []

    ###
    @property {ByUserStats[]} Stats by manager
    ###
    byManager: []

    ###
    @property {ByCategoryStats[]} Stats by category
    ###
    byCategory: []

    ###
    @property {ByStatusStats[]} Stats by status
    ###
    byStatus: []

    ###
    @property {ByDateStats} Stats by date
    ###
    byDate: []


  ###
  @property {Array} Nested entities
  ###
  relations: [
      type:         Backbone.One
      key:          'general'
      relatedModel: StatsData
    ,
      type:         Backbone.Many
      key:          'byUser'
      relatedModel: ByUserStats
    ,
      type:         Backbone.Many
      key:          'byManager'
      relatedModel: ByUserStats
    ,
      type:         Backbone.Many
      key:          'byCategory'
      relatedModel: ByCategoryStats
    ,
      type:         Backbone.Many
      key:          'byStatus'
      relatedModel: ByStatusStats
    ,
      type:         Backbone.One
      key:          'byDate'
      relatedModel: ByDateStats
  ]
