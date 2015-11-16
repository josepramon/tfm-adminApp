ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'
i18n     = require 'i18next-client'


module.exports = class SetPasswordView extends ItemView
  template: require './templates/setPassword.hbs'

  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Set new password'
