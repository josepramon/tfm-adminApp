CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'
ListItemView  = require './FooterNavItemView'


###
Footer view
============

@class
@augments CompositeView

###
module.exports = class FooterView extends CompositeView

  template: require './templates/footer.hbs'
  className: 'inner'

  childView: ListItemView
  childViewContainer: 'ul'
