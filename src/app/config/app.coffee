###
Application configuration
==========================

@type {Object}

###
module.exports =

  # default application radio channel
  appChannel: 'MosaiqoApp'

  # API params (base url, etc)
  API:
    # All the API urls are something like /api/whatever
    # if rootURL has a value, '/api' will ve replaced by it
    #
    # example:
    #   rootURL: '/api/v1'
    #   rootURL: 'http://whatever'
    #
    # rootURL can also be overrided by creating a file called '.env.json' at the
    # project root with something like:
    #
    # ```
    # {
    #   "api": {
    #     "rootURL": "http://mosaiqo.local/api/v1"
    #   }
    # }
    # ```
    #
    # Here the default url should be deffined (the production url or null to call /api).
    # While developing you should override this using the envFile.
    #
    rootURL: null


  # The app uses media queries to adapt the UI to the different devices,
  # but there're some situations where that's not enough. For example,
  # on smaller screens the menu fills the whole screen and should be collapsed
  # after the user selects some action.
  #
  # If the layout width is less or equal to this, the app will perform some
  # additional actions in some situations.
  mobileLayoutWidth: 650
