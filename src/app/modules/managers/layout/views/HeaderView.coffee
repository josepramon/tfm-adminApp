ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'
_        = require 'underscore'
i18n     = require 'i18next-client'


module.exports = class ManagersHeader extends ItemView

  template: require './templates/header.hbs'

  serializeData: ->
    ret = @model.toJSON()
    ret = _.omit(ret, 'action') if ret.action is i18n.t('List')
    ret
