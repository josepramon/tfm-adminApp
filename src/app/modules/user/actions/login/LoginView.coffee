ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'
i18n     = require 'i18next-client'


module.exports = class LoginView extends ItemView
  template: require './templates/login.hbs'

  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Login'
