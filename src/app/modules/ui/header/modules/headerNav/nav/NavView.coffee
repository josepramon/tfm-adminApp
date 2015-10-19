ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Header navigation view
=======================

@class
@augments ItemView

###
module.exports = class NavView extends ItemView
  template: require './templates/headerNav.hbs'

  id: 'headerNav'

  tagName: 'ul'

  triggers:
    'click [href=#logout]' : 'nav:logout'
    'click [href=#help]'   : 'nav:help'
