# Dependencies
# -----------------------

# Libs/generic stuff:
i18n                    = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView                = require 'msq-appbase/lib/appBaseComponents/views/ItemView'

# View behaviours
TaggableBehaviour       = require 'msq-appbase/lib/behaviours/Taggable'
CategorizableBehaviour  = require 'msq-appbase/lib/behaviours/Categorizable'
CSSclassChangeBehaviour = require 'msq-appbase/lib/behaviours/CSSclassChanger'
EditorBehaviour         = require 'msq-appbase/lib/behaviours/Editor'


###
Article edit view
=======================

@class
@augments CompositeView

###
module.exports = class PostEditView extends ItemView
  template: require './templates/edit.hbs'
  className: 'sectionContainer'


  ###
  @property {Object} view behaviours config.
  ###
  behaviors:
    # change the icon on the 'publish status' block
    # when the user changes the article publish status
    CSSclassChanger:
      behaviorClass: CSSclassChangeBehaviour
      input:  '[name="publishStatus"]'
      target: '#publishedStatusIcon'
      cssClasses:
        'unpublished': 'icon icon-toggle-off text-muted'
        'published':   'icon icon-toggle-on text-success'
        'scheduled':   'icon icon-clock-o'

    Taggable:
      behaviorClass: TaggableBehaviour

    Categorizable:
      behaviorClass: CategorizableBehaviour

    Editor:
      behaviorClass: EditorBehaviour


  ###
  @property {Object} form config.
  ###
  form:
    buttons:
      primaryActions:
        primary:
          text: -> i18n.t 'Save'
          icon: 'check'
        cancel:
          text: -> i18n.t 'Cancel'
      secondaryActions:
        delete:
          type:      'delete'
          className: 'btn btn-danger'
          text:      -> i18n.t 'Delete'
          icon:      'trash'


  ###
  @property {Object} DOM elements
  ###
  ui:
    'publishStatusRadios' : '[name="publishStatus"]'
    'publishDateFields'   : '[name^="publishDate["]'


  ###
  @property {Object} handlers config. for UI elements
  ###
  events:
    'change @ui.publishStatusRadios': 'togglePublishDateFields'


  ###
  Handler executed when the view is rendered
  ###
  onRender: ->
    @togglePublishDateFields()


  ###
  Enable the publish date fields only if the publishStatus is 'scheduled'
  ###
  togglePublishDateFields: ->
    status = @ui.publishStatusRadios.filter(':checked').val()

    if status is 'scheduled'
      @ui.publishDateFields.removeAttr 'disabled'
    else
      @ui.publishDateFields.attr 'disabled', 'disabled'
