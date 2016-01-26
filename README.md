# Mosaiqo Helpdesk admins app

Part of the Mosaiqo Helpdesk system, developed as my [final project](http://hdl.handle.net/10609/45241) for the _[Multimedia applications: design and development of smart content](http://estudis.uoc.edu/ca/masters-universitaris/aplicacions-multimedia/)_ Master's degree at Universitat Oberta de Catalunya.

The project consists on the design and development of a web based help desk, using modern methodologies and architectures in web development, such as Single Page Applications, RESTful APIs, Node.js and NoSQL databases, implemented using new languages as CoffeeScript, Stylus or ES6, prioritizing the usability and performance of all the components of the system to provide an optimal experience on any kind of devices.

Warning: This is the first realease of the project, so it may not be ready fot production.

![Mosaiqo Helpdesk](https://cloud.githubusercontent.com/assets/870039/12579954/03c795c2-c42c-11e5-9218-854c0fb225d7.jpg)

## Prerequisites:

To build the app, node and npm must be installed. Once installed, install the application dependencies:

```
npm install
```

Some of the components might have some dependencies that need to be installed in order to run correctly.

If the `npm install` or the `grunt` commands fail, check the output. Some systems have that libraries already installed, others not and require a manual install. For example, on Ubuntu 14.04.3 LTS, the following libraries needed to be installed:

- imagemagick
- libpng-dev
- optipng


## Build

To set the API url, create a file on the project root called `env.json` with the desired url, for example:

```
{
  "api": {
    "rootURL": "http://192.168.1.10:8000/api"
  }
}
```

The URL can be changed later without recompiling, editing the variable `MOSAIQO_API_ROOT_URL` on the `index.html` file generated during the build in the `dist` directory.

There are two grunt tasks available to build the project:

- The default one, `grunt`, builds the application for production, with the assets minified and some other optimisations (*warning:* this task also enables *appcache*, which is not ready at this point of the development process)
- The task `grunt dev`, bulds the application in development mode, without minification, with source maps, and also starts a simple HTTP server to test the application. While the task is active (it can be terminated with `CTR+C`), the task _watches_ the source directory and automatically executes the tsts and rebuilds the application if any file is changed.

There're some other tasks, documented in `grunt/aliases.yml`.


## Application language

The application is language independent, with all the messages defined inside external locale files.

The locale files are located inside the `src/app/locales` directory. Currently the available application locales are english, catalan and spanish.

To set the application default language, add a `lang` key to the `env.json` file and rebuild the project. The avalue must be the 2 letter language code.

For example:

```
{
  "lang": "ca"
}
```

It's possible to change the language without rebuilding the project changing the `lang` attribute of the `html` tag on `dist/index.html`


## Other customisations

The links on the footer can be customised adding to the `env.json` file a node called "footer" with something like:

```
{
  "footer": [
    { "text": "About us", "url": "http://whatever.com/about" },
    { "text": "Legal", "url": "http://whatever.com/legal" },
    { "text": "contact", "url": "contact.html" }
  ]
}
```

and rebuild the project.

Any other customisation requires editing the code.
