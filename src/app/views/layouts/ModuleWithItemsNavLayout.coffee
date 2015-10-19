LayoutView           = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'
CollapsibleBehaviour = require 'msq-appbase/lib/behaviours/CollapsibleModuleItems'


###
Generic section layout with nav
=================================

Generic layout for modules that always show the module items navigation

@class
@augments LayoutView

###
module.exports = class ModuleWithItemsNavLayout extends LayoutView

  template: require './templates/mainItemAreaWithItemsList.hbs'

  className: 'inner'

  regions:
    header:    'header'
    main:      '#contentEditArea'
    itemsList: '#moduleItems > .outer'

  behaviors:
    CollapsibleModuleItems:
      behaviorClass: CollapsibleBehaviour
