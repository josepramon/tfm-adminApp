LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'


# Users module layout
#
module.exports = class Layout extends LayoutView

  template: require './templates/usersLayout.hbs'

  className: 'inner'

  regions:
    header: '#moduleHeader'
    main:   '#moduleContent'
