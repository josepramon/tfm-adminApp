_ = require 'underscore'


module.exports = (grunt) ->
  locales:
    command: ->

      locales = grunt.file.readJSON('./config/locales.json')

      cmd  = 'node_modules/i18next-parser/bin/cli.js <%= srcDir %>/app -o <%= srcDir %>/app/locales -r'

      cmd += ' -s ' + locales.namespaceSeparator
      cmd += ' -k ' + locales.keySeparator
      cmd += ' -n ' + locales.namespace
      cmd += ' -l ' + _.keys locales.locales

      ###
      hack: i18next-parser does not support multiple paths or incremental builds.
      In addition to the app directory, is necessary to scan the "msq-appbase" node
      module (a set of generic libs, classes, etc).
      So, create a symbolic link before the scan and remove afterwards.
      ###
      cmd_pre =  'cd <%= srcDir %>/app/;'
      cmd_pre += 'ln -s ../../node_modules/msq-appbase/lib __lib__;'
      cmd_pre += 'cd -'
      cmd_post = 'rm <%= srcDir %>/app/__lib__'
      cmd = cmd_pre + '; ' + cmd + '; ' + cmd_post

      cmd

  docs:
    command: 'node_modules/docker/docker -i src/app -o docs/dist/annotated-source'

  modernizr:
    command: ->
      binPath    = 'node_modules/modernizr/bin/modernizr'
      configFile = 'config/modernizr.json'
      output     = '<%= assetsDir %>/js/vendor/modernizr-custom.js'
      "#{binPath} -c #{configFile} -d #{output}"
