# Stylus to CSS transpiler
# @see https://github.com/gruntjs/grunt-contrib-stylus
module.exports =

  # global options
  options:
    # use embedurl('test.png') in our code to trigger Data URI embedding
    urlfunc: 'embedurl'


  # main styles:
  # ---------------------------------------------------------------

  # production mode
  main:
    options:
      banner: '<%= banner %>'
      linenos:  false
      compress: true
      firebug:  false
      use: [
        require('kouto-swiss')
        () -> require('autoprefixer-stylus') browsers: ['last 2 versions', 'ie 9']
        () -> require('csso-stylus') restructure: false
      ]
    files: [
      # main css
      '<%= assetsDir %>/css/main.css': '<%= srcDir %>/styles/index.styl'
    ,
      # themes
      expand: true
      cwd: '<%= srcDir %>/styles/themes/'
      src: ['**/index.styl']
      dest: '<%= assetsDir %>/css/themes/'
      ext: '.css'
      rename: (dest, src) -> dest + src.replace('index.css', 'main.css')
    ,
      # modules
      expand: true
      cwd: '<%= srcDir %>/styles/modules/'
      src: ['**/index.styl']
      dest: '<%= assetsDir %>/css/modules/'
      ext: '.css'
      rename: (dest, src) -> dest + src.replace('index.css', 'main.css')
    ]

  # dev mode
  dev:
    options:
      banner: '<%= banner %>'
      linenos:  true
      compress: false
      firebug:  false # setting to true breaks some things like @import rules
                      # so enable at your own risk
      use: [
        require('kouto-swiss')
        () -> require('autoprefixer-stylus') browsers: ['last 2 versions', 'ie 9']
      ]
    files: '<%= stylus.main.files %>'


  # theme
  # ---------------------------------------------------------------

  # production mode
  theme:
    options:
      linenos:  false
      compress: true
      firebug:  false
      use: [
        () -> require('autoprefixer-stylus') browsers: ['last 2 versions', 'ie 9']
        () -> require('csso-stylus') restructure: false
      ]
    files:
      '<%= assetsDir %>/css/theme.css': '<%= srcDir %>/styles/theme.styl'

  # dev mode
  theme_dev:
    options:
      linenos:  true
      compress: false
      firebug:  false # setting to true breaks some things like @import rules
                      # so enable at your own risk
      use: [
        () -> require('autoprefixer-stylus') browsers: ['last 2 versions', 'ie 9']
      ]
    files: '<%= stylus.theme.files %>'
