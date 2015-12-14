# Grunt task to automate environment configuration for future tasks
# @see https://github.com/jsoverson/grunt-env
module.exports =
  options: {}
  dev:
    NODE_ENV:     'DEVELOPMENT'
    API_ROOT_URL: '<%= api.rootURL %>'
    APP_LANG:     '<%= lang %>'
  production:
    NODE_ENV :    'PRODUCTION'
    API_ROOT_URL: '<%= api.rootURL %>'
    APP_LANG:     '<%= lang %>'
