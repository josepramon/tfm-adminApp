# @see http://www.browsersync.io/docs/grunt/
module.exports =
  options:
    port: '<%= ports.server %>'
    ui:
      port: '<%= ports.browserSyncUI %>'
      weinre:
        port: '<%= ports.weinre %>'

  dev:
    bsFiles:
      src: '<%= assetsDir %>/**/*.*'
    options:
      watchTask: true
      server:
        baseDir: '<% buildDir %>'
        index: 'index.html'
