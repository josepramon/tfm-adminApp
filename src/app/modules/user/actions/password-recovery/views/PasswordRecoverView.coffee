ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'
i18n     = require 'i18next-client'


module.exports = class PasswordRecoveryView extends ItemView
  template: require './templates/passwordRecovery.hbs'

  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Recover password'
