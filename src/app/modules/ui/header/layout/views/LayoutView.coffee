LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'


###
Header layout
==============

@class
@augments LayoutView

###
module.exports = class HeaderView extends LayoutView
  template: require './templates/headerLayout.hbs'

  className: 'inner'

  regions:
    languageSwitcher: '#languageSwitcherContainer'
    headerNav:        '#headerNavContainer'
    userWidget:       '#userWidgetContainer'

  triggers:
    'click #globalNavToggler' : 'layout:collapse'
