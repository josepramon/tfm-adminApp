i18n = require 'i18next-client'

###

Custom strings for the translations
====================================

This is a special file and its not used anywhere

The purpose of this file is only to add additional
strings to translate when executing the command

 `grunt locales`

That command scans all the source files and searches
for strings to localise. The strings are added to the
locale files. If a previously found string is removed
from the source file (for example a view or a template)
it will also be removed from the locales.

So, in order to include some additional strings (for
dynamic stuff) in the locales and keep off the generator
from removing it, just add it here

###

i18n.t 'modules::Dashboard'
i18n.t 'modules::Posts'
i18n.t 'modules::Tags'
i18n.t 'modules::Categories'
i18n.t 'modules::User'
