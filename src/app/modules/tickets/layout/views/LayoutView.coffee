LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'


# Tickets module layout
#
# @module tickets
#
module.exports = class Layout extends LayoutView

  template: require './templates/layout.hbs'

  className: 'inner'

  regions:
    header:    '#moduleHeader'
    main:      '#moduleContent'
