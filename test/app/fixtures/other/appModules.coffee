Module = require 'msq-appbase/lib/appBaseComponents/modules/Module'


class FakeModule1 extends Module
  meta:
    title: 'FakeModule1'
    icon:  'some-icon'
    showInModuleNavigation: true
    stopable: true
    localeNS : 'FakeModule1NS'

class FakeModule2 extends Module
  startWithParent: false
  meta:
    title: 'FakeModule2'
    icon:  'some-icon'
    showInModuleNavigation: true
    stopable: true
    localeNS : 'FakeModule2NS'

class FakeModule3 extends Module
  meta:
    title: 'FakeModule3'
    icon:  'some-icon'
    showInModuleNavigation: true
    stopable: true
    localeNS : 'FakeModule3NS'

class FakeModule4 extends Module


module.exports = [
  id:    'FakeModule1'
  class: FakeModule1
,
  id:    'FakeModule2'
  class: FakeModule2
  submodules: [
    id:    'FakeModule3'
    class: FakeModule3
  ,
    id:    'FakeModule4'
    class: FakeModule4
  ]
]
