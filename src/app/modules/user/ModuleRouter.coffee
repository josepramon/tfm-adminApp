Router = require 'msq-appbase/lib/appBaseComponents/Router'


###
User module router
====================

@class
@augments Router

###
module.exports = class ModuleRouter extends Router

  ###
  @property {Object} Module routes
                     similar to Marionette's appRoutes
                     but automatically prefixed with the
                     module rootUrl (supplied in the constructor)
  ###
  prefixedAppRoutes:
    '/login'     : 'login'
    '/profile'   : 'profile'
    '/authError' : 'authError'
