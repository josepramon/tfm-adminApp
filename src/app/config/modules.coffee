###
Application submodules
=======================

Right now loading and starting them all, but this can be changed if the
modules are loaded conditionally according to the user privileges, or
something like that

@type {Array}

###
module.exports = [
    id:    'User'
    class: require 'modules/user'
    submodules: []
  ,
    id:    'Dashboard'
    class: require 'modules/dashboard'
  ,
    id:    'Managers'
    class: require 'modules/managers'
  ,
    id:    'Uploads'
    class: require 'modules/uploads'
  ,
    id:    'KnowledgeBase'
    class: require 'modules/knowledge_base'
    submodules: [
      id:    'Dashboard'
      class: require 'modules/knowledge_base/modules/dashboard'
    ,
      id:    'Posts'
      class: require 'modules/knowledge_base/modules/posts'
    ,
      id:    'Tags'
      class: require 'modules/knowledge_base/modules/tags'
    ,
      id:    'Categories'
      class: require 'modules/knowledge_base/modules/categories'
    ]
  ,
    id:    'Tickets'
    class: require 'modules/tickets'
    submodules: [
      id:    'Dashboard'
      class: require 'modules/tickets/modules/dashboard'
    ,
      id:    'Tickets'
      class: require 'modules/tickets/modules/tickets'
    ,
      id:    'Categories'
      class: require 'modules/tickets/modules/categories'
    ,
      id:    'Statuses'
      class: require 'modules/tickets/modules/statuses'
    ,
      id:    'Uncategorised'
      class: require 'modules/tickets/modules/uncategorised'
    ]
  ,
    id: 'UI'
    submodules: [
      id:    'Header'
      class: require 'modules/ui/header'
      submodules: [
        id:    'HeaderNav'
        class: require 'modules/ui/header/modules/headerNav'
      ,
          id:  'User'
        class: require 'modules/ui/header/modules/user'
      ]
    ,
      id:    'Footer'
      class: require 'modules/ui/footer'
    ,
      id:    'Nav'
      class: require 'modules/ui/navigation'
    ]
]
