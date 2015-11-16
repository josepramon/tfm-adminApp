LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'


# Knowledge Base module layout
#
# @module kb
#
module.exports = class Layout extends LayoutView

  template: require './templates/layout.hbs'

  className: 'inner'

  regions:
    header:    '#moduleHeader'
    main:      '#moduleContent'
