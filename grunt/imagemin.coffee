# Automatic image optimization
# @see https://github.com/gruntjs/grunt-contrib-imagemin
module.exports =
  options:
    cache: false

  dist:
    files: [
      expand: true,
      cwd: '<%= srcDir %>/images/',
      src: ['**/*.{png,jpg,gif}'],
      dest: '<%= assetsDir %>/images/'
    ]
