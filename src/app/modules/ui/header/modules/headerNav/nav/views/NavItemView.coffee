ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Header navigation view
=======================

@class
@augments ItemView

###
module.exports = class NavItemView extends ItemView
  template: require './templates/headerNavItem.hbs'
  tagName: 'li'
