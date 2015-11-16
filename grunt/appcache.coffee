# App cache builder
# @see https://www.npmjs.org/package/grunt-appcache
module.exports =
  options:
    basePath: 'dist'
    preferOnline: true
    ignoreManifest: false

  dist:
    dest: 'dist/manifest.appcache'
    cache:
      patterns: [
        'dist/**/*' # all the resources in 'dist/'
        '!dist/assets/vendor/**/*' # except the 'dist/vendor/' subtree
        '!dist/assets/js/**/*.map'
        'dist/assets/vendor/requirejs/require.js'
        'dist/assets/vendor/pace/themes/blue/pace-theme-minimal.css'
        'dist/assets/vendor/pace/pace.min.js'
      ]
      literals: [
        # font-awesome
        'http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css'
        'http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/fonts/fontawesome-webfont.eot?v=4.2.0'
        'http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/fonts/fontawesome-webfont.woff?v=4.2.0'
        'http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/fonts/fontawesome-webfont.ttf?v=4.2.0'
        'http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/fonts/fontawesome-webfont.svg?v=4.2.0'

        # Google fonts
        'http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,700italic,400,300,600,700'
        'http://fonts.googleapis.com/css?family=Armata'

        # insert '/' as is in the "CACHE:" section
        '/'
      ]
    network: '*'
    fallback: '/ /error/offline.html'

