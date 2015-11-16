# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
Controller = require 'msq-appbase/lib/appBaseComponents/controllers/Controller'

# Action controllers
LoginController                       = require './actions/login/LoginController'
AccountController                     = require './actions/account/AccountController'
ProfileController                     = require './actions/profile/ProfileController'
AuthErrorController                   = require './actions/error/AuthErrorController'
PasswordRecoveryController            = require './actions/password-recovery/PasswordRecoveryController'
PasswordRecoverySetPasswordController = require './actions/password-recovery-set-password/SetPasswordController'
AccountActivationController           = require './actions/account-activation/ActivationController'




###
User module main controller
============================

The class forwards the calls deffined in a module router to the appropiate
CRUD methods in the speciallised controllers (each controller is only responsible
for a task, like editing a record, or listing them).

@class
@augments Controller

###
module.exports = class ModuleController extends Controller

  #  Controller API:
  #  --------------------
  #
  #  Methods used by the router (and may be called directly from the module, too)

  login: ->
    new LoginController()

  logout: ->
    @appChannel.request 'auth:logout'

  account: ->
    if @_checkAccess()
      new AccountController()

  profile: ->
    if @_checkAccess()
      new ProfileController()

  authError: ->
    new AuthErrorController()

  recoverPassword: ->
    new PasswordRecoveryController()

  ###
  @param {String} id Password recovery request id
  ###
  recoverPassword_setPassword: (id) ->
    new PasswordRecoverySetPasswordController
      id: id

  ###
  @param {String} id Activation request id
  ###
  account_activate: (id) ->
    new AccountActivationController
      id: id



  ###
  Limit the access to authenticated users
  ###
  _checkAccess: ->
    @appChannel.request 'auth:requireAuth', null, false
