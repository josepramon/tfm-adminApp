# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
_    = require 'underscore'
i18n = require 'i18next-client'


module.exports = class StatsDataModel extends Model

  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {Number} Total tickets
    ###
    total: 0

    ###
    @property {Number} Closed tickets
    ###
    closed: 0

    ###
    @property {Number} Open tickets
    ###
    open: 0

    ###
    @property {Number} Tickets assigned to some manager
    ###
    assigned: 0

    ###
    @property {Number} Unassigned tickets
    ###
    unassigned: 0

    ###
    @property {Object} Resolution times (in miliseconds)
    ###
    resolutionTime:
      min:     0
      max:     0
      average: 0
