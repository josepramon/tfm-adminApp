# Dependencies
# -------------------------

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Ticket model
Ticket = require './Ticket'


###
Tickets Collection
===================

@class
@augments Collection

###
module.exports = class TicketsCollection extends Collection
  model: Ticket
  url: '/api/tickets/tickets'
