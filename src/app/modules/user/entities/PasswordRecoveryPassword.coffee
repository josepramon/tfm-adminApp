# Dependencies
# -------------------------

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Libs/generic stuff:
i18n  = require 'i18next-client'




###
Password recovery new pass model
=================================

@class
@augments Model

###
module.exports = class PasswordRecoveryPassword extends Model

  # @property [String] API url
  urlRoot: '/api/auth/recover'


  ###
  @property {Object} Model validation rules
  ###
  validation:
    password:
      required: true
    rePassword:
      equalTo: 'password'


  ###
  @property {Object} Custom attribute labels
                     Used by the validator when building the error messages
  @static
  ####
  @labels:
    password:    -> i18n.t 'UserModel::password'
    rePassword:  -> i18n.t 'UserModel::rePassword'


  ###
  Override the patch method

  By default, when a model is processed using the form module,
  if the model is not new (has an id), the call to the server
  is a PATCH with only the changed attributes.
  When processing this model, a PUT with the entire model
  representation should be performed.
  ###
  patch: (data, options = {}) ->
    @set data, options
    @save null, options



  ###
  Save error handler

  The API throws a 404 error if the password recovery request does not
  exist anymore (it can only be used once and automatically expire
  after certain amount of time). This is fine, but the generic error
  displayed is a bit weird in this situation. So override it and display
  something more appropiate.
  ###
  saveError: (model, xhr, options = {}) =>
    if xhr.status is 404
      @dispatchCustomValidationError
        request: [i18n.t 'Password reset request expired.']
    super model, xhr, options
