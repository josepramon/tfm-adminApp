ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'
_        = require 'underscore'
i18n     = require 'i18next-client'


module.exports = class UsersHeader extends ItemView

  template: require './templates/usersHeader.hbs'

  ui:
    moduleNavBtns: '.moduleNavigation a'
    accountBtn:    '#accountBtn'
    profileBtn:    '#profileBtn'

  serializeData: ->
    ret = @model.toJSON()
    ret = _.omit(ret, 'action') if ret.action is i18n.t('List')
    ret


  onRender: ->
    @ui.moduleNavBtns.removeClass 'active'

    parentModule = @model.get 'parentModule'
    module       = @model.get 'module'
    action       = @model.get 'action'
    btn          = null

    if action is i18n.t('user::Account') then btn = @ui.accountBtn
    if action is i18n.t('user::Profile') then btn = @ui.profileBtn

    if btn
      btn.addClass 'active'
