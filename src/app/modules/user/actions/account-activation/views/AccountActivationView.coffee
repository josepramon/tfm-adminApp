ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'
i18n     = require 'i18next-client'


module.exports = class AccountActivationView extends ItemView
  template: require './templates/accountActivation.hbs'

  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Activate account'
