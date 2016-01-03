Ticket = require './Ticket'


module.exports = class UncategorisedTicket extends Ticket

  ###
  @property {String} API url
  ###
  urlRoot: '/api/tickets/uncategorised'
