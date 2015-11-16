ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'


###
Language switcher view
=======================

@class
@augments ItemView

###
module.exports = class LangSelectorView extends ItemView
  template: require './templates/langSelector.hbs'

  ui:
    'langSwitcher' : '#languageSwitcher'
    'toggler'      : '#languageSwitcherToggler'


  events:
    'change @ui.langSwitcher' : 'handleLanguageChange'
    'click  @ui.toggler'      : 'toggleDropdown'



  collectionEvents:
    'select:one' : 'updateLanguage'


  onRender: ->
    # initialize the dropdown
    $select    = @ui.langSwitcher.selectize()
    @selectize = $select[0].selectize


  ###
  Language droopdown change handler

  When the language is changed, bubbles up the event
  ###
  handleLanguageChange: ->
    @trigger 'change:language', @ui.langSwitcher.val()


  ###
  Select some language on the droopdown

  @param {Language} selectedModel        the selected language model
  @param {LanguageCollection} collection the languages collection
  ###
  updateLanguage: (selectedModel, collection) ->
    @ui.langSwitcher.val selectedModel.get 'lang'
    @selectize.setValue selectedModel.get 'lang'


  ###
  Open/close the languages menu
  ###
  toggleDropdown: ->
    if @selectize.isOpen
      @selectize.close()
    else
      @selectize.open()
