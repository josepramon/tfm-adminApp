ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


# TMP. view
#
# @extend ItemView
# @module _placeholderModule
#
module.exports = class ListView extends ItemView
  template: require './templates/list.hbs'
