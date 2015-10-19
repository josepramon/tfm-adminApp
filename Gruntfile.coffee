module.exports = (grunt) ->

  _ = require('underscore')

  # Defaults:
  # ================================================================
  defaults =
    api:
      rootURL: ''


  # The defaults can be overrided so you can place the API wherever you want.
  #
  # Just create a file called '.env.json' at the project root and overwrite any
  # default settings you want
  #
  envConfigFile = '.env.json'

  if grunt.file.exists envConfigFile
    envConfig = grunt.file.readJSON(envConfigFile)
  else
    envConfig = {}

  config = _.defaults envConfig, defaults


  # Data available to the tasks:
  # The previous config plus some aditional params.
  config = _.extend config,
    # Directories:
    srcDir:    'src'
    buildDir:  'dist'
    testDir:   'test'
    assetsDir: '<%= buildDir %>/assets'
    libDir:    '<%= assetsDir %>/vendor'
    docsDir:   'docs'

    # Files:
    libFile: '<%= assetsDir %>/js/lib.js'

    # Server port, used on the devperf task:
    serverPort: 9000

    # Banner, appended to the built scripts/css:
    banner: '/*! <%= package.name %> <%= package.version %> |
© <%= package.author %> - All rights reserved |
<%= package.homepage %> */\n'



  # Autoloading for the grunt tasks, jitGrunt enables loading them on demand
  require('load-grunt-config') grunt,
    jitGrunt: true
    data:     config


  # Display the elapsed execution time of grunt tasks
  require('time-grunt') grunt

  # Load explicitly the notify tasks,
  # otherwise, no notifications will be fired or errors
  grunt.loadNpmTasks('grunt-notify')
