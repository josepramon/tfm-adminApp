Handlebars  = require 'handlebars/runtime'

localisedFieldsFormTmpl = require './partials/templates/localisedFieldsForm.hbs'
Handlebars.registerPartial 'localisedFieldsForm', localisedFieldsFormTmpl

breadcrumbsTmpl = require './partials/templates/breadcrumbs.hbs'
Handlebars.registerPartial 'breadcrumbs', breadcrumbsTmpl
