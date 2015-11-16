ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
User widget view
=======================

@class
@augments ItemView

###
module.exports = class UserWidgetView extends ItemView
  template: require './templates/userWidget.hbs'

  className: 'userWidget'

  modelEvents:
    'change': 'render'
