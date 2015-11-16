ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Nav. item view
================

@class
@augments ItemView

###
module.exports = class NavItemView extends ItemView

  template: require './templates/navItem.hbs'
  tagName: 'li'
