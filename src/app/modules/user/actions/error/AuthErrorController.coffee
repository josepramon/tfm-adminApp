_              = require 'underscore'
ViewController = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'
ErrorView      = require './ErrorView'


# User module auth error controller
module.exports = class AuthErrorController extends ViewController

  # Controller initialization
  #
  initialize: ->
    view  = @getErrorView()

    # render the login form
    @show view


  # Error view getter
  #
  # @return {ErrorView}
  #
  getErrorView: (model) ->
    new ErrorView()
