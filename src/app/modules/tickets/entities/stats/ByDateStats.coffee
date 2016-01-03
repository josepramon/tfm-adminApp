# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
_         = require 'underscore'
i18n      = require 'i18next-client'
factory   = require 'msq-appbase/lib/utilities/factory'




module.exports = class ByDateStatsModel extends Model

  ###
  @property {String} API url
  ###
  url: '/api/tickets/stats/byDate'

  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {Object[]} Ticket creation dates,
                         something like {"2015":8}, where the value is the amount
                         of tickets created on that date
    ###
    created:  []

    ###
    @property {Object[]} Ticket close dates,
                         something like {"2015":8}, where the value is the amount
                         of tickets created on that date
    ###
    closed:   []

    ###
    @property {Object[]} Ticket reopening dates,
                         something like {"2015":8}, where the value is the amount
                         of tickets created on that date
    ###
    reopened: []
