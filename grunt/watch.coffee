# File changes watcher
# @see https://github.com/gruntjs/grunt-contrib-watch
module.exports =
  coffee_app:
    files: ['<%= srcDir %>/app/**/*.coffee']
    #tasks: ['coffeelint:app', 'karma:dev:run', 'browserify:dev_app']
    tasks: ['coffeelint:app',  'browserify:dev_app']

  coffee_lib:
    files: ['<%= srcDir %>/app/lib.coffee']
    tasks: ['coffeelint:app', 'browserify:dev_lib']

  stylus:
    files: '<%= srcDir %>/styles/**/*.styl'
    tasks: ['stylus:dev']

  images:
    files: '<%= srcDir %>/images/**/*.*'
    tasks: ['images']

  views:
    files: '<%= srcDir %>/html/**/*.*'
    tasks: ['assemble:site', 'preprocess:site']

  tests:
    files: ['<%= testDir %>/app/**/*.coffee']
    #tasks: ['coffeelint:tests', 'karma:dev:run']
    tasks: ['coffeelint:tests']

  locales:
    files: ['<%= srcDir %>/app/locales/**/*.json']
    tasks: ['clean:locales', 'copy:locales']
