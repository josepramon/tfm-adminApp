CollectionView = require 'msq-appbase/lib/appBaseComponents/views/CollectionView'
ListItemView   = require './NavItemView'


###
Nav. view
===========

@class
@augments ItemView

###
module.exports = class NavView extends CollectionView

  tagName:   'ul'
  id:        'modules'
  childView: ListItemView


  triggers:
    'click a':
      event:          'nav:section:selected'
      preventDefault: false


  ###
  Highligths the active section

  @param {String} itemHref  the active section link href attribute
  ###
  setActiveItem: (itemHref) ->
    @$el.find('a').removeClass 'active'

    current = @$el.find 'a[href="#' + itemHref + '"]'
    current.addClass 'active'

    if current.parents('.modulesNav').length
      current.parents('.modulesNav').prev('a').addClass 'active'
