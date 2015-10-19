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
    id:    'Pages'
    class: require 'modules/pages'
  ,
    id:    'Blog'
    class: require 'modules/blog'
    submodules: [
      id:    'Dashboard'
      class: require 'modules/blog/modules/dashboard'
    ,
      id:    'Posts'
      class: require 'modules/blog/modules/posts'
    ,
      id:    'Tags'
      class: require 'modules/blog/modules/tags'
    ,
      id:    'Categories'
      class: require 'modules/blog/modules/categories'
    ]
  ,
    id:    'Store'
    class: require 'modules/store'
  ,
    id:    'Media'
    class: require 'modules/media'
  ,
    id:    'Comments'
    class: require 'modules/comments'
  ,
    id:    'Analytics'
    class: require 'modules/analytics'
  ,
    id:    'Auth'
    class: require 'modules/auth'
  ,
    id:    'Settings'
    class: require 'modules/settings'
  ,
    id: 'UI'
    submodules: [
      id:    'Header'
      class: require 'modules/ui/header'
      submodules: [
        id:    'HeaderNav'
        class: require 'modules/ui/header/modules/headerNav'
      ,
        id:    'LanguageSwitcher'
        class: require 'modules/ui/header/modules/languageSwitcher'
      ]
    ,
      id:    'Footer'
      class: require 'modules/ui/footer'
    ,
      id:    'Nav'
      class: require 'modules/ui/navigation'
    ]
]
