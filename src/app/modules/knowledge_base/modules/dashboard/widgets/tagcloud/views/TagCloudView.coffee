ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Knowledge base tag cloud view
==============================

@class
@augments CompositeView

###
module.exports = class TagCloudView extends ItemView
  template: require './templates/tagCloud.hbs'
  className: 'panel panel-default'

  onRender: ->
    opts =
      autoResize: true
      height:     130

    words = @collection.map (tag) ->
      text:   tag.get 'name'
      weight: tag.get('articles').length
      link:   '#knowledge-base/tags/' + tag.get('id') + '/edit'

    # although verything should have been rendered and
    # the DOM should be ready, this does not work if
    # executed immediatelly, so add a little delay
    setTimeout (=>
      @$('.panel-body').jQCloud words, opts
    ), 500
