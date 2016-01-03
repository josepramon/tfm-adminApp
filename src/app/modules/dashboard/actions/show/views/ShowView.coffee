# Dependencies
# -----------------------

# Libs/generic stuff:
_      = require 'underscore'
i18n   = require 'i18next-client'

# Base class
LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'


###
Dashboard view
=======================

@class
@augments ItemView

###
module.exports = class DashboardView extends LayoutView
  template:  require './templates/dashboard.hbs'
  className: 'sectionContainer dashboard'

  ###
  Widget regions:
  ###
  regions:
    ticketsWidgetRegion: '#stats-byDate-container'
    kbWidgetRegion:      '#stats-kb-container'
    usersWidgetRegion:   '#stats-users-container'
