# Admins app

## Prerequisites:

To build the app, node and npm must be installed. Once installed, install the application dependencies:

```
npm install
```

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
