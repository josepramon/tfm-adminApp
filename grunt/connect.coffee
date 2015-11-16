# https://github.com/gruntjs/grunt-contrib-connect
module.exports =
  server:
    options:
      port: '<%= posts.server %>'
      base: '<%= buildDir %>'
      index: 'index.html'
