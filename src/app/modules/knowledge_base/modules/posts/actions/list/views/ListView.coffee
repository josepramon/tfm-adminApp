# Dependencies
# -----------------------

# Base class (extends Marionette.CompositeView)
CompositeView              = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'

# ItemView
ListItemView               = require './ListItemView'

# View behaviours
InfiniteScrollingBehaviour = require 'msq-appbase/lib/behaviours/InfiniteScrolling'




###
Knowledge Base posts module list
=================================

@class
@augments CompositeView

###
module.exports = class PostsListView extends CompositeView

  template: require './templates/list.hbs'
  className: 'inner'


  childView: ListItemView
  childViewContainer: '.items'


  ###
  @property {Object} DOM elements
  ###
  ui:
    createItemBtn: '#moduleItemsCreate'


  ###
  @property {Object} View triggers
  ###
  triggers:
    'click @ui.createItemBtn': 'create:kb:post'


  ###
  @property {Object} view behaviours config.
  ###
  behaviors:
    InfiniteScrolling:
      behaviorClass: InfiniteScrollingBehaviour
