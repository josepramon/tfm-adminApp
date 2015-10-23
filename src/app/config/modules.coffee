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
