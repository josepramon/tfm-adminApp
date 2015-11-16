# Generates favicon.ico and icons for iOS, Android, Windows 8 and Firefox (OS)
#
# Requires ImageMagick installed on the system
#
# @see https://www.npmjs.org/package/grunt-favicons
module.exports =
  options: {

    # Instead of updating each html file, just update the favicons.hbs
    # template, which will be included in each view by the assemble task
    html : '<%= srcDir %>/html/partials/favicons.hbs'

    # Path to the icons
    HTMLPrefix : 'assets/icons/'

    # Bg color, IOS does not accept transparent icons
    appleTouchBackgroundColor: '#ffffff'
  }

  icons: {

    # src image used to generate the icons
    src: 'src/images/icons/logo.png',

    # Path to the directory where the icons will be generated
    dest: '<%= assetsDir %>/icons'
  }
