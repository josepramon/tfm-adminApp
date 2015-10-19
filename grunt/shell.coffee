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

      cmd

  docs:
    command: 'node_modules/docker/docker -i src/app -o docs/dist/annotated-source'

  modernizr:
    command: ->
      binPath    = 'node_modules/modernizr/bin/modernizr'
      configFile = 'config/modernizr.json'
      output     = '<%= assetsDir %>/js/vendor/modernizr-custom.js'
      "#{binPath} -c #{configFile} -d #{output}"
