Collection = require 'msq-appbase/lib/appBaseComponents/entities/Collection'
Language   = require './Language'
Select     = require 'backbone.select'


###
Language Collection
====================

@class
@augments Collection

###
module.exports = class LanguageCollection extends Collection
  model: Language

  initialize: (models, options) ->
    # apply the backbone.select mixin
    Select.One.applyTo @, models, options
