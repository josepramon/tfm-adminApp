LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'


# Managers module layout
#
module.exports = class Layout extends LayoutView

  template: require './templates/layout.hbs'

  className: 'inner'

  regions:
    header: '#moduleHeader'
    main:   '#moduleContent'
