# Dependencies
# -----------------------

# Libs/generic stuff:
i18n     = require 'i18next-client'

# Base class (extends Marionette.ItemView)
ItemView = require 'msq-appbase/lib/appBaseComponents/views/ItemView'




###
Ticket comment view
====================

@class
@augments ItemView

###
module.exports = class CommentView extends ItemView

  template: require './templates/comment.hbs'
  tagName : 'li'
  className: 'comment'


  onRender: ->
    if @model.get 'private'
      @$el.addClass 'comment-private'

    u = @model.get 'user'

    if u
      userType = u.get '__t'
      if userType is 'Manager' then @$el.addClass 'comment-agentComment'
