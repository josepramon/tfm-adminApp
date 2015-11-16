# @see https://github.com/sindresorhus/grunt-concurrent
module.exports =
  assetsDev:
    tasks: ['scripts_debug', 'css_debug', 'images']
    options:
      logConcurrentOutput: true
