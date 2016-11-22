# ComplianceOps

## quick start

```sh
npm install -g elm@0.18.0
elm-app start
```

### Safety at speed
By connecting activities to policies to values & customer requirements, we help organizations avoid getting bogged down in rules that no longer make sense, and empower people to update practices to use modern tools and techniques without abandoning responsible oversight and administrative controls.

### Design & Documention
[Design ideas](https://paper.dropbox.com/doc/Design-Ideas-IM45aAXQEvSZWd1cqNJ4p)

This project was bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app) and then ejected.

## Installing Elm packages

```sh
elm-package install <package-name>
```

## Installing JavaScript packages

To use JavaScript packages from npm, you'll need to add a `package.json`, install the dependencies and you're ready to go.

```sh
npm init -y # Add package.json
npm install --save-dev pouchdb-browser # Install library from npm
```

```js
// Use in your JS code
var PouchDB = require('pouchdb-browser');
var db = new PouchDB('mydb');
```

## Folder structure
```
my-app/
  .gitignore
  README.md
  elm-package.json
  src/
    favicon.ico
    index.html
    index.js
    main.css
    Main.elm
  tests/
    elm-package.json
    Main.elm
    Tests.elm
```
For the project to build, these files must exist with exact filenames:

- `src/index.html` is the page template;
- `src/favicon.ico` is the icon you see in the browser tab;
- `src/index.js` is the JavaScript entry point.

You can delete or rename the other files.

You may create subdirectories inside src.

## Available scripts
In the project directory you can run:
### `npm run-script build`
Builds the app for production to the `dist` folder.  

The build is minified and the filenames include the hashes.  
Your app is ready to be deployed!

### `npm run-script start`
Runs the app in the development mode.  
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.  
You will also see any lint errors in the console.

### `npm run-script test`
Run tests with [node-test-runner](https://github.com/rtfeldman/node-test-runner/tree/master)
