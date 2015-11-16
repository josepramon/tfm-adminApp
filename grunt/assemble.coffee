# Static html builder from handlebars templates
# @see http://assemble.io
module.exports =
  options:
    plugins:   []

  site:
    options:
      partials:  '<%= srcDir %>/html/partials/**/*.hbs'
      layoutdir: '<%= srcDir %>/html/layouts'
      layout:    'default.hbs'
      data:      '<%= srcDir %>/html/data/*.{json,yml}'
    cwd:       '<%= srcDir %>/html/views/'
    src:       '**/*.hbs'
    dest:      '<%= buildDir %>'
    expand:    true
