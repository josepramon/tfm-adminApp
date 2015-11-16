# Automatic notifications when Grunt tasks fail and custom notifications
# @see https://github.com/dylang/grunt-notify
module.exports =
  images:
    options:
      message: 'Images optimization complete'

  buildComplete:
    options:
      message: 'Build complete'
