# Admins app

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
