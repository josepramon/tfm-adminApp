# Coffeescript linter
# @see https://www.npmjs.org/package/grunt-coffeelint
module.exports =
  options:
    configFile: 'config/coffeelint.json'

  app:   ['src/app/**/*.coffee']
  tests: ['test/app/**/*.coffee']
  grunt: ['Gruntfile.coffee', 'grunt/*.coffee']
