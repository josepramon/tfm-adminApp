LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'


###
Knowledge base dashboard view
==============================

@class
@augments LayoutView

###
module.exports = class DashboardView extends LayoutView
  template:  require './templates/dashboard.hbs'
  className: 'sectionContainer dashboard'

  # widget regions
  regions:
    region1: '#dashboard-region1'
    region2: '#dashboard-region2'
    region3: '#dashboard-region3'
    region4: '#dashboard-region4'
