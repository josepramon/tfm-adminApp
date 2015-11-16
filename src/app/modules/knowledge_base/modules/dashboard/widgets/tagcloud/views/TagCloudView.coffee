ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Knowledge base tag cloud view
==============================

@class
@augments ItemView

###
module.exports = class TagCloudView extends ItemView
  template: require './templates/tagCloud.hbs'
  className: 'panel panel-default'

  onRender: ->
    opts =
      autoResize: true
      height:     130

    words = @collection.map (tag) ->
      tagWeight = tag.get('articles')?.state?.totalRecords or 0
      {
        text:   tag.get 'name'
        weight: tagWeight
        link:   '#knowledge-base/tags/' + tag.get('id') + '/edit'
      }

    # although everything should have been rendered and
    # the DOM should be ready, this does not work if
    # executed immediatelly, so add a little delay
    setTimeout (=>
      @$('.panel-body').jQCloud words, opts
    ), 500
