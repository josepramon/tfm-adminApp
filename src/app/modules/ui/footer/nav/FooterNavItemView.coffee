ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Footer nav. item view
=======================

@class
@augments ItemView

###
module.exports = class FooterNavItemView extends ItemView

  template: require './templates/footerListItem.hbs'
  tagName: 'li'
