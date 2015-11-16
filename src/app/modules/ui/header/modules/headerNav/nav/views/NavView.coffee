CollectionView = require 'msq-appbase/lib/appBaseComponents/views/CollectionView'
ListItemView   = require './NavItemView'

###
Header navigation view
=======================

@class
@augments CollectionView

###
module.exports = class NavView extends CollectionView
  template: require './templates/headerNav.hbs'

  id: 'headerNav'
  tagName: 'ul'

  childView: ListItemView
  childViewContainer: 'ul'
