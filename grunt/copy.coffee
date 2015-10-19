# Copy files and folders
# @see https://github.com/gruntjs/grunt-contrib-copy
module.exports =
  fonts:
    expand: true
    flatten: true
    src: [
      '<%= libDir %>/kaleidoscope/dist/fonts/*'
    ]
    dest: '<%= assetsDir %>/fonts/'
    filter: 'isFile'

  locales:
    expand: true
    cwd: '<%= srcDir %>/app/locales'
    src: ['**/*', '!**/*_old.json']
    dest: '<%= assetsDir %>/locales/'
    filter: 'isFile'
