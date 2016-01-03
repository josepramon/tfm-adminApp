# Dependencies
# -------------------------

# Base class (extends Backbone.Collection)
Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'

# Ticket model
UncategorisedTicket = require './UncategorisedTicket'


###
Uncategorised Tickets Collection
==================================

@class
@augments Collection

###
module.exports = class UncategorisedTicketsCollection extends Collection
  model: UncategorisedTicket
  url: '/api/tickets/uncategorised'
