ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'
_        = require 'underscore'
i18n     = require 'i18next-client'


module.exports = class Header extends ItemView

  template: require './templates/header.hbs'

  ui:
    moduleNavBtns:  '.moduleNavigation a'
    dashboardBtn:   '#dashboardBtn'
    postsBtn:       '#postsBtn'
    postsCreateBtn: '#postsCreateBtn'
    commentsBtn:    '#commentsBtn'
    tagsBtn:        '#tagsBtn'
    categoriesBtn:  '#categoriesBtn'

  serializeData: ->
    ret = @model.toJSON()
    ret = _.omit(ret, 'action') if ret.action is i18n.t('List')
    ret


  onRender: ->
    @ui.moduleNavBtns.removeClass 'active'

    parentModule = @model.get 'parentModule'
    module       = @model.get 'module'
    action       = @model.get 'action'
    moduleName   = if module then module.name else ''
    btn          = null

    if moduleName is i18n.t('modules::KnowledgeBase') and !action then btn = @ui.dashboardBtn

    if moduleName is i18n.t('modules::KBPosts') and action is i18n.t('List')   then btn = @ui.postsBtn
    if moduleName is i18n.t('modules::KBPosts') and action is i18n.t('Edit')   then btn = @ui.postsBtn
    if moduleName is i18n.t('modules::KBPosts') and action is i18n.t('Create') then btn = @ui.postsCreateBtn

    if moduleName is i18n.t('modules::KBTags')       then btn = @ui.tagsBtn
    if moduleName is i18n.t('modules::KBCategories') then btn = @ui.categoriesBtn

    if btn
      btn.addClass 'active'
