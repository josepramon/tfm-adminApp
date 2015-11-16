ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Tickets dashboard view
=======================

@class
@augments ItemView

###
module.exports = class TicketsShowView extends ItemView

  template: require './templates/show.hbs'
  className: 'sectionContainer'

  modelEvents:
    'change' : 'render'
