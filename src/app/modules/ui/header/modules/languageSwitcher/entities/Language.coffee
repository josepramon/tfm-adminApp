Model  = require 'msq-appbase/lib/appBaseComponents/entities/Model'
Select = require 'backbone.select'


###
Language Model
===============

@class
@augments Model

###
module.exports = class Language extends Model

  ###
  @property {Object} Model default attributes
  ###
  defaults:
    ###
    @property {String} Language code
    ###
    lang: ''

    ###
    @property {String} Label, language name displayed
    ###
    label: null


  ###
  Model initialization
  ###
  initialize: ->
    # apply the backbone.select mixin
    Select.Me.applyTo @
