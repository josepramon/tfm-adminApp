Radio = require 'backbone.radio'

# module event bus, independent from the application one
module.exports = Radio.channel('Mosaiqo.tmpModule')
