# Locales

The application is localized in several languages using the library [i18next](http://i18next.com/).

When defining a string to be shown to the user in the application, use one of the i18next helpers to make it translatable:

For example, in a coffee file:

```coffeescript
i18n = require 'i18next-client'

msg  = i18n.t 'This message will be displayed in the user language'
console.log msg
```

Or in a handlebars template:

```handlebars
<em>{{t "This message will be displayed in the user language"}}</em>
```

Translation keys can be grouped, for example:

```handlebars
<nav>
  <ul>
    <li><a href="#">{{t "nav::Home"}}</a></li>
    <li><a href="#">{{t "nav::Latest news"}}</a></li>
    <li><a href="#">{{t "nav::Contact"}}</a></li>
  </ul>
</nav>

<h1>{{t "Some title"}}</h1>
<p>{{t "Lorem ipsum dolor sit amet, consectetur adipiscing elit."}}</p>
```

The translation file for the following block will be something like:

```json
{
  "nav": {
    "Home":        "Pàgina d'inici",
    "Latest news": "Últimes notícies",
    "Contact":     "Contacte"
  },
  "Some title": "Un títol",
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.": "Blablabla"
}
```

It's also possible to define a *namespace*. Different namespaces will generate multiple translation files. Currently the app uses one generic namespace called *app* (it's the default namespace, so there's no need to specify it), and one additional namespace for each module. On production, all the files for the different namespaces will be concatenated into a single file (**TODO: implement the locale concatenation**).

For example, the following code:

```handlebars
<h1>{{t "a string to translate"}}</h1>
<ul>
  <li>{{t "someModuleNS:::another string to translate"}}</li>
  <li>{{t "someModuleNS:::foo::this will be translated too"}}</li>
</ul>
```

will generate 2 translation files:

app.json:

```json
{
  "a string to translate" : "whatever"
}
```

someModuleNS.json:

```json
{
  "another string to translate": "...",
  "foo": {
    "this will be translated too": "..."
  }
}
```

The locale files are located in the directory `src/app/locales/`, within a subdirectory for each language.

There's no need to add/remove translation keys manually on the locale files.  Just execute `grunt locales` on the commanline.  
That command scans all the source files and searches for strings to localize and will add them to the locale files.  
If a previously found string is removed from the source file (for example a view or a template) it will also be removed from the locales.

In order to include some additional strings (for dynamic stuff) in the locales and keep off the generator from removing it, just add it to the file `src/app/config/forcedLocaleStrings.coffee`. This file will not be compiled into the app, its used only to add additional stuff in the generated locales.

The configuration for the locale generator command is defined on the file `config/locales.json`. Just add any additional language there in order to generate locales for that.
