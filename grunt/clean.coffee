# Generated directory and file cleaner
# @see https://github.com/gruntjs/grunt-contrib-clean
module.exports =
  scripts:
    src: ['<%= assetsDir %>/js']

  styles:
    src: ['<%= assetsDir %>/css', '<%= assetsDir %>/fonts']

  images:
    src: ['<%= assetsDir %>/images']

  docs:
    src: ['<%= docsDir %>/dist']

  html:
    src: ['<%= buildDir %>/*.html']

  appcache:
    src: ['<%= buildDir %>/*.appcache']

  locales:
    src: ['<%= assetsDir %>/locales']
