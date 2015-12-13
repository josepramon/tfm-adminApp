$          = require 'jquery'
_          = require 'underscore'
enquire    = require 'enquire.js'
LayoutView = require 'msq-appbase/lib/appBaseComponents/views/LayoutView'

ModalRegion = require '../regions/ModalRegion'

# Other
mobileLayoutWidth = require('config/app').mobileLayoutWidth


###
Aplication layout
==================

Main application layout (application regions have been deprecated)

@class
@augments LayoutView

###
module.exports = class AppLayout extends LayoutView
  template: require './templates/app.hbs'
  el: '.appContainer'


  ###
  @property {Object} layout regions
  ###
  regions:
    mainRegion:   '#wrapper main'
    headerRegion: '> header'
    footerRegion: '> footer'
    navRegion:    '#globalNav'
    modalRegion:
      el:          '#modal-region'
      regionClass: ModalRegion


  ###
  @property {Object} child view events
  ###
  childEvents:
    'nav:section:selected': 'navSectionSelected'


  ###
  Layout initialization
  ###
  initialize: () ->
    # Sidebar collapsing for narrow screens (like tablets on portrait
    # or resized browser windows)
    # Not implemented using only css media queries because there's
    # enought screen space to show the sidebar,
    # so by default collapse it and let the user expand it
    enquire.register 'screen and (max-width: 900px)', [
        match: =>
          @collapse true
      ,
        unmatch: =>
          @collapse false
    ]

    # if the regions are rerendered after enquire has run,
    # make sure they have the approppiate classes
    @listenTo @headerRegion, 'show', =>
      unless _.isUndefined @layoutCollapsed
        @collapse @layoutCollapsed

    @listenTo @navRegion, 'show', =>
      unless _.isUndefined @layoutCollapsed
        @collapse @layoutCollapsed

    # Fix for some styling issues on IOS when the app is 'saved'
    # (share->add to home screen)
    if window.navigator.standalone
      $('html').addClass('ios-standalone')


  ###
  Layout collapse/uncollapse

  Toggles the 'collapsed' state that makes
  the header and navigation more compact

  @param {Boolean} collapsed
  ###
  collapse: (collapsed) ->
    if _.isUndefined collapsed
      collapsed = if _.isUndefined @layoutCollapsed then true else !@layoutCollapsed

    @layoutCollapsed = collapsed
    @headerRegion.$el.add(@navRegion.$el).toggleClass('collapsed', collapsed)


  ###
  Nav. handler

  On small screens, collapse the layout after selecting an option
  ###
  navSectionSelected: =>
    unless @viewport
      @viewport = $(window)

    if @viewport.width() <= mobileLayoutWidth
      @collapse true


  ###
  Authentication status

  Toggles the 'authenticated' CSS class on the layout
  container, so the UI can be addapted if the user is
  authenticated or not.

  @param {Boolean} status  whether the user is authenticated or not
  ###
  setAuthenticationStatus: (status) ->
    @$el.toggleClass('authenticated', status)
