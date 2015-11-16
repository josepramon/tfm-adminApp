_ = require('underscore')


###
Privileges comparison utility:

Compares some requested privileges with a set of provided ones
(for example the ones form the authenticated user)

This is somewhat complex. See the API project (this has been adapted form a
privilegesAccessFilter middleware). That project contains more info and tests
to demonstrate how this exactly works.

@return {Boolean} true if the requested privileges are satisfied, false otherwise
###
checkPrivileges = (requiredPermissions, userPermissions) ->
  
  # if no permissions are required just continue
  if !requiredPermissions
    return true

  # if any permission defined, the user must be authenticated,
  # and must have some permissions assigned
  unless userPermissions
    return false

  # compare the required privileges with the user ones
  return isAllowed requiredPermissions, userPermissions



###
Aux. recursive method to compare the required privileges with the user ones

@return {Boolean} True if all the required permissions are satisfied, or false
@private
###
isAllowed = (requiredPermissions, userPermissions) ->
  _.reduce requiredPermissions, ((accessGranted, val, key) ->
    # if any previous check has returned false, there's no need to keep checking
    if !accessGranted
      return false

    requestedPermission = val
    userPermission      = userPermissions[key]

    if !userPermission
      # if the user privileges does not contain the node, deny the access
      return false

    else if _.isBoolean(requestedPermission)
      # global (boolean) privilege required
      if _.isBoolean(userPermission)
        # the user privilege is also global, allow access if the values match
        return requestedPermission and userPermission

      else
        # the required privilege is global, but the user has an specific one, so denied
        false

    else if _.isBoolean(userPermission)
      # specific permission required, but the user has a global (boolean) one
      return userPermission

    else

      # complex scenario: the node has an 'actions' node inside,
      # and/or a nested structure (a 'modules node')
      actions = true
      modules = true
      # check actions
      if requestedPermission.actions
        actions = isActionsAllowed(requestedPermission.actions, userPermission.actions)
      # check nested modules
      if requestedPermission.modules
        # recurse
        modules = isAllowed(requestedPermission.modules, userPermission.modules)

      return actions and modules

  ), true



###
Aux. method to compare permissions on the `actions` nodes

@return {Boolean} True if all the required permissions are satisfied, or false
@private
###
isActionsAllowed = (requiredActions, userActions) ->
  if !requiredActions or !_.keys(requiredActions).length
    return true

  if !userActions or !_.keys(userActions).length
    return false

  _.reduce requiredActions, ((memo, v, k) ->
    if !memo
      return false

    if userActions[k]
      # the key is present on the both params
      return v and userActions[k]

    else
      # the key is present only on the first param.
      # if the val is true the requirement is not matched
      # if it's false, it is
      return !v
  ), true


module.exports = checkPrivileges
