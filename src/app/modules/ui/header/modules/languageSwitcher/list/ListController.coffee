# Dependencies
# -----------------------

# Base class (extends Marionette.Controller)
ViewController     = require 'msq-appbase/lib/appBaseComponents/controllers/ViewController'

# Entities
LanguageCollection = require '../entities/LanguageCollection'

# The view
View               = require './views/LangSelector'




###
Language switcher view controller
==================================

@class
@augments ViewController

###
module.exports = class ListController extends ViewController

  ###
  Controller initialization
  ###
  initialize: ->
    @langs = @getLanguages()
    @view  = @getView @langs

    # change the application language when the user selects a new one
    @listenTo @view, 'change:language', (lang) =>
      @appChannel.request 'locale:set', lang

    # if the language is changed somewhere else, update thew selection
    @listenTo @appChannel, 'locale:loaded', (lang) =>
      @selectLang lang

    # render
    @show @view

    # select the current lang
    @selectLang @appChannel.request 'locale:get'


  ###
  Controller destroy method
  ###
  destroy: ->
    @view.destroy()
    @langs = null
    super


  # Aux
  # -----------------

  ###
  View getter

  Instantiates this controller's view
  passing to it any required data

  @param  {Collection}
  @return {View}
  ###
  getView: (data) ->
    new View
      collection: data


  ###
  Languages collection getter

  Instantiates the collection that will feed the view

  @return {Collection}
  ###
  getLanguages: ->
    locales = @appChannel.request 'locale:entities'

    new LanguageCollection locales


  ###
  Select some language from the list

  Used when the view is rendered to preselect the applied language

  @param {String} lang  active language code
  ###
  selectLang: (lang) ->
    selectedLang = @langs.findWhere 'lang':lang

    if selectedLang
      selectedLang.select()
