# Dependencies
# -----------------------

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Tickets comment no-data view
============================================

@class
@augments ItemView

###
module.exports = class NoDataView extends ItemView

  template: require './templates/noComments.hbs'
  tagName : 'li'
