ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'
_        = require 'underscore'
i18n     = require 'i18next-client'


module.exports = class Header extends ItemView

  template: require './templates/header.hbs'

  ui:
    moduleNavBtns:    '.moduleNavigation a'
    dashboardBtn:     '#dashboardBtn'
    ticketsBtn:       '#ticketsBtn'
    tagsBtn:          '#tagsBtn'
    categoriesBtn:    '#categoriesBtn'
    statusesBtn:      '#statusesBtn'
    uncategorisedBtn: '#uncategorisedBtn'

  serializeData: ->
    ret = @model.toJSON()
    ret = _.omit(ret, 'action') if ret.action is i18n.t('List')
    ret


  onRender: ->
    @ui.moduleNavBtns.removeClass 'active'

    module       = @model.get 'module'
    action       = @model.get 'action'
    moduleName   = if module then module.name else ''
    btn          = null

    if moduleName is i18n.t('modules::Tickets') and !action then btn = @ui.dashboardBtn

    if moduleName is i18n.t('modules::TicketsManage')        then btn = @ui.ticketsBtn
    if moduleName is i18n.t('modules::TicketsCategories')    then btn = @ui.categoriesBtn
    if moduleName is i18n.t('modules::TicketsStatuses')      then btn = @ui.statusesBtn
    if moduleName is i18n.t('modules::TicketsUncategorised') then btn = @ui.uncategorisedBtn

    if btn
      btn.addClass 'active'
