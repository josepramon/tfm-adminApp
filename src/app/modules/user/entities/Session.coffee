# Dependencies
# -------------------------

# Libs/generic stuff:
$     = require 'jquery'
_     = require 'underscore'

# Base class (extends Backbone.Model)
Model = require 'msq-appbase/lib/appBaseComponents/entities/Model'

# Utility to compare privileges
checkPrivileges = require './util/PrivilegesChecker'



###
Session model
==============

This is a somewhat special model because it does not belong to any collection
and it's a singleton. Also this model is does not have a server side corresponding

@class
@augments Model

###
module.exports = class Session extends Model

  ###
  @property {String} API url
  ###
  urlRoot: '/api/auth'

  ###
  @property {String} model id attribute
  ###
  idAttribute: 'token'


  ###
  @property {Object} Model default attributes
  ###
  defaults:
    id             : null
    token          : null
    token_iat      : null
    token_exp      : null
    username       : ''
    email          : ''
    role           : ''
    privileges     : null


  ###
  Timestamp fields

  js represents timestamps in miliseconds but the API represents that in seconds
  this fields will be automatically converted when fetching/saving

  @property {String[]} the attributes to transform
  ###
  timestampFields: ['created_at', 'updated_at', 'token_iat', 'token_exp']


  # Returns whether there's a valid session and it hasn't expired
  #
  #
  # It does not verify the validity of the session at the server side
  # @return {Boolean}
  #
  isAuthenticated: ->
    if !@get 'token' then false else !@isExpired()


  # Privileges verification
  hasAccess: (requiredPermissions) ->
    return @isAuthenticated && checkPrivileges(requiredPermissions, @get 'privileges')


  ###
  Checks if the session is expired

  @return {Boolean}
  ###
  isExpired: ->
    ret = true
    if @get 'token_exp'
      expiry = new Date(@get 'token_exp')
      now    = new Date()
      ret = expiry.getTime() < now.getTime()
    ret


  ###
  Server side token verification

  Checks if the token is valid and it hasn't expired

  @param {Function} successCb success callback, executed if the token is valid
  @param {Function} errorCb   error callback, executed if the token is not valid or has expired
  ###
  verify: (successCb, errorCb) ->
    $.get( @url() )
    .done( -> if _.isFunction successCb then successCb() )
    .fail( -> if _.isFunction errorCb then errorCb() )


  ###
  Token renewal

  @param {Function} successCb success callback, executed if the token is successfully renewed
  @param {Function} errorCb   error callback, executed if the token can't be renewed
  ###
  renew: (successCb, errorCb) ->
    # callbacks
    success = (data) =>
      # `@save data` is roughly equivalent to `@set data` followed by `@save`
      # Here i'm using the second form so it can be easily tested, with no need
      # to mock the save operation
      # Is necessary ro call model.parse to apply any required transform like
      # unwrapping the data or converting timestamps to the appropiate format
      data = @parse data
      @set data
      @save()

      # execute the callback, if any
      if _.isFunction successCb then successCb data

    err = (jqXHR, textStatus, errorThrown) ->
      if _.isFunction errorCb then errorCb jqXHR.responseJSON

    # perform the renewal request
    $.ajax({ url: @url(), type: 'PUT' }).done(success).fail(err)


  ###
  Model initialization
  ###
  initialize: ->
    super arguments

    # When the 'session' is active, hijack the ajax calls adding the
    # authorization headers. Also add an error handler for auth. errors.
    $.ajaxPrefilter (opts, originalOpts, jqXHR) =>
      # The API might be on the same server serving the app, or might be elsewhere.
      # If the API is on an external server, a prefilter before this one will setup
      # the url base and required headers. In that situation, it will also add a new
      # attribute to the opts object called originalUrl, in order to check if the
      # request is on the API or elsewhere
      url = opts.originalUrl or opts.url


      # only if the user is authenticated and only when calling the API
      if @isAuthenticated() and /^\/api/.test url
        jqXHR.setRequestHeader 'authorization', 'Bearer ' + @get 'token'

        # trigger a custom error if the server returns a 401
        error = opts.error
        opts.error = (jqXHR, textStatus, errorThrown) =>
          if jqXHR.status is 401
            # don't throw 401 errors when logging out to avoid recursion
            unless opts.type is 'DELETE' and /^\/api\/auth\//.test url
              @trigger 'authError'

          # fire the original callback
          if _.isFunction error then error(jqXHR, textStatus, errorThrown)
