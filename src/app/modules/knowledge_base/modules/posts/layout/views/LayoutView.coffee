# Dependencies
# -----------------------

# Base class (extends Marionette.LayoutView)
LayoutView           = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'

# View behaviours
CollapsibleBehaviour = require 'msq-appbase/lib/behaviours/CollapsibleModuleItems'

# Other
mobileLayoutWidth = require('config/app').mobileLayoutWidth




###
Knowledge Base module layout
============================

@class
@augments LayoutView

###
module.exports = class Layout extends LayoutView

  template: require './templates/postsLayout.hbs'
  className: 'inner'


  ###
  @property {Object} layout regions
  ###
  regions:
    main:      '#contentEditArea'
    itemsList: '#moduleItems > .outer'


  ###
  @property {Object} view behaviours config.
  ###
  behaviors:
    CollapsibleModuleItems:
      behaviorClass: CollapsibleBehaviour
      autoToggle:    true
      contentRegion: 'main'
      autoToggleOnlyIfWidthLessThan: mobileLayoutWidth
