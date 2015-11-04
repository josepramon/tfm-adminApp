ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'
i18n     = require 'i18next-client'


module.exports = class RegisterView extends ItemView
  template: require './templates/register.hbs'

  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Register'
