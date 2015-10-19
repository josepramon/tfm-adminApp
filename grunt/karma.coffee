appFiles = ['dist/assets/js/lib.js', 'src/app/**/*.coffee']

module.exports = (grunt) ->

  # shared config
  options:
    configFile: 'config/karma.coffee'
    reporters:  ['mocha', 'notify']
    exclude:    ['src/app/main.coffee']

  # task targets:
  # --------------------
  unit:
    options:
      files: appFiles.concat ['test/app/unit/**/*.coffee']

  integration:
    options:
      files: appFiles.concat ['test/app/integration/**/*.coffee']

  functional:
    options:
      files: appFiles.concat ['test/app/functional/**/*.coffee']

  acceptance:
    options:
      files: appFiles.concat ['test/app/acceptance/**/*.coffee']

  # executed during the main 'dev' task by grunt-contrib-watch
  dev:
    options:
      files:      ['test/app/unit/**/*.coffee']
      autoWatch:  false
      singleRun:  false
      background: true


  # execute all the tests
  all:
    options:
      files:      appFiles.concat ['test/app/**/*.coffee']
      singleRun:  true

  # execute all the tests on all the browsers
  allBrowsers:
    options:
      files:      appFiles.concat ['test/app/**/*.coffee']
      browsers:   ['PhantomJS', 'Chrome', 'Safari', 'Firefox', 'Opera']
      singleRun:  true

  # execute all the tests and generate a coverage report - not working currently :(
  coverage:
    options:
      files:     appFiles.concat ['test/app/**/*.coffee']
      singleRun: true
      reporters: ['mocha', 'notify', 'coverage']
      preprocessors:
        'src/app/**/*.coffee': [ 'coverage' ]
        'test/**/*.coffee': [ 'browserify' ]
