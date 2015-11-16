# @see https://github.com/gruntjs/grunt-contrib-htmlmin
module.exports =
  dist:
    options:
      removeComments: true
      collapseWhitespace: true
    files: [
      expand: true
      cwd:    '<%= buildDir %>'
      src:    ['**/*.html', '!assets/vendor/**/*.html',]
      dest:   '<%= buildDir %>'
    ]
