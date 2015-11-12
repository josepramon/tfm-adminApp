# Dependencies
# -----------------------

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Knowledge Base posts list no results view
============================================

@class
@augments ItemView

###
module.exports = class NoDataView extends ItemView

  template: require './templates/noData.hbs'
  tagName : 'li'
  className: 'noData'
