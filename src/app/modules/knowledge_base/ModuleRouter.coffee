Router = require 'msq-appbase/lib/appBaseComponents/Router'


###
Blog dashboard router
======================

@class
@augments Router

###
module.exports = class ModuleRouter extends Router

  ###
  @property {Object} Module routes
  ###
  appRoutes:
    '' : 'show'

  ###
  @property {Object} Module routes
                     similar to Marionette's appRoutes
                     but automatically prefixed with the
                     module rootUrl (supplied in the constructor)
  ###
  prefixedAppRoutes:
    '' : 'redirectToRoot'
    # articles list by category
    # search results
    # detail
