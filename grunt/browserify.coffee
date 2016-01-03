# https://www.npmjs.com/package/grunt-browserify
minify = (b, output) ->
  if output
    opts =
      map:    output.match(/\/([^/]*)$/)[1]
      output: output
  else
    opts = {}

  b.plugin 'minifyify', opts


taskOpts =
  app:
    files:     '<%= assetsDir %>/js/main.js' : ['<%= srcDir %>/app/main.coffee']
    paths:     ['<%= srcDir %>/app']
    external:  [
      'modernizr'
      'jquery'
      'underscore'
      'underscore.string'
      'underscore-deep-extend'
      'backbone'
      'backbone.radio'
      'backbone.syphon'
      'backbone.marionette'
      'backbone.webStorage'
      'backbone.paginator'
      'backbone-computedfields'
      'backbone-associations'
      'backbone-validation'
      'backbone.select'
      'backgrid'
      'enquire'
      'moment'
      'i18next-client'
      'toastr'
      'dropzone'
      'bootbox'
    ]

  lib:
    files:     '<%= assetsDir %>/js/lib.js' : ['<%= srcDir %>/app/lib.coffee']
    alias:  [
      'jquery:'
      'underscore:'
      'underscore.string:'
      'underscore-deep-extend:'
      'backbone:'
      'backbone.radio:'
      'backbone.syphon:'
      'backbone.marionette:'
      'backbone.webStorage:'
      'backbone.paginator:'
      'backbone-computedfields:'
      'backbone-associations:'
      'backbone-validation:'
      'backbone.select:'
      'backgrid:'
      'enquire.js:'
      'moment:'
      'i18next-client:'
      'toastr:'
      'dropzone:'
      'bootbox:'
    ]


module.exports = (grunt) ->

  options:
    browserifyOptions:
      paths: taskOpts.app.paths
      extensions: ['.js', '.coffee', '.json']
      debug: true

  # production
  app:
    files:       taskOpts.app.files
    options:
      transform: ['coffeeify', 'hbsfy', ['envify', {CUSTOM_FOOTER: '<%= footer %>'}]]
      external:  taskOpts.app.external
      banner:    '<%= banner %>'
      plugin: [
        [ (b) -> b.plugin 'licensify', {scanBrowser: true} ]
        [ (b) -> minify b ]
      ]

  lib:
    files:       taskOpts.lib.files
    options:
      transform: ['coffeeify']
      alias:     taskOpts.lib.alias
      plugin: [
        [ (b) -> b.plugin 'licensify', {scanBrowser: true} ]
        [ (b) -> minify b ]
      ]

  # dev/watch
  dev_app:
    files:       taskOpts.app.files
    options:
      transform: ['coffeeify', 'hbsfy', ['envify', {CUSTOM_FOOTER: '<%= footer %>'}]]
      external:  taskOpts.app.external
      plugin: [[ (b) -> minify b, 'dist/assets/js/app.map' ]]

  dev_lib:
    files:       taskOpts.lib.files
    options:
      transform: ['coffeeify']
      alias:     taskOpts.lib.alias
      plugin: [[ (b) -> minify b, 'dist/assets/js/lib.map' ]]
