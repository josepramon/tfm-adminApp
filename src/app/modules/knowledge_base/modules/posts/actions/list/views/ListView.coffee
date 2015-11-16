# Dependencies
# -----------------------

# Base class (extends Marionette.CompositeView)
CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'

# Aux. views
ListItemView = require './ListItemView'
NoDataView   = require './NoDataView'

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
  emptyView: NoDataView


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
    'submit':                  'kb:search:submit'
    'reset':                   'kb:search:reset'


  ###
  @property {Object} view behaviours config.
  ###
  behaviors:
    InfiniteScrolling:
      behaviorClass: InfiniteScrollingBehaviour


  ###
  Inject some additional data
  ###
  serializeData: ->
    data = super()

    if @collection and @collection.isSearchResults
      data.isSearch = true
      if @collection.searchQuery
        data.searchQuery = @collection.searchQuery

    data
