# Preprocess HTML and JavaScript directives based off environment configuration
# @see https://www.npmjs.org/package/grunt-preprocess/
module.exports =
  site:
    src:  '<%= buildDir %>/*.html'
    options:
      inline : true
      context :
        appName:     '<%= package.name %>',
        appVersion : '<%= package.version %>',
