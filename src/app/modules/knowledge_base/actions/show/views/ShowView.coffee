ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Blog dashboard view
=======================

@class
@augments ItemView

###
module.exports = class KnowledgeBaseShowView extends ItemView

  template: require './templates/show.hbs'
  className: 'sectionContainer'

  modelEvents:
    'change' : 'render'
