###
3rd party deppendencies
========================
###


# General utilities
# -----------------------------------------------
_                  = require 'underscore'
_s                 = require 'underscore.string'
Moment             = require 'moment'
i18n               = require 'i18next-client'

# make jQuery global so it can be used by plugins and other libs.
window.$ = window.jQuery = require 'jquery'



# Backbone, Mationette and related libs
# -----------------------------------------------
Backbone           = require 'backbone'
Backbone.$         = $ # attach jQuery to Backbone
Marionette         = require 'backbone.marionette'
Radio              = require 'backbone.radio'
Syphon             = require 'backbone.syphon'
WebStorage         = require 'backbone.webStorage'
PageableCollection = require 'backbone.paginator'
Associations       = require 'backbone-associations'
Computedfields     = require 'backbone-computedfields'
Validation         = require 'backbone-validation'
Select             = require 'backbone.select'
Backgrid           = require 'backgrid'
BackgridPaginator  = require 'backgrid-paginator'



# Other stuff
# -----------------------------------------------
Enquire            = require 'enquire.js'
Bootstrap          = require 'bootstrap'
toastr             = require 'toastr'



# jQuery plugins
# -----------------------------------------------
require 'jquery-scrollstop'
require 'selectize'
