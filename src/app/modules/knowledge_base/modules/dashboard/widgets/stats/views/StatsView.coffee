CompositeView = require 'msq-appbase/lib/appBaseComponents/views/CompositeView'
StatView       = require './StatView'


###
Knowledge base stats view
==========================

@class
@augments CompositeView

###
module.exports = class StatsView extends CompositeView
  template: require './templates/stats.hbs'
  className: 'panel panel-default'

  childView: StatView
  childViewContainer: '.stats'

