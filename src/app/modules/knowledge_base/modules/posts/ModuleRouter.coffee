Router = require 'msq-appbase/lib/appBaseComponents/Router'


###
Knowledge Base posts router
============================

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
    '/new'                    : 'create'
    '/:id/edit'               : 'edit'
    '/byTag/:tagId'           : 'listTagArticles'
    '/byCategory/:categoryId' : 'listCategoryArticles'
    ''                        : 'list'
