# Web UI SPA

This project was initially bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

## Turning off Elm Debugger

To turn off Elm Debugger, set `ELM_DEBUGGER` environment variable to `false`

## Adding a Stylesheet

This project setup uses [Webpack](https://webpack.js.org/) for handling all
assets. Webpack offers a custom way of “extending” the concept of `import`
beyond JavaScript. To express that a JavaScript file depends on a CSS file,
you need to **import the CSS from the JavaScript file**:

### `main.css`

```css
body {
  padding: 20px;
}
```

### `index.js`

```js
import "./main.css"; // Tell Webpack to pick-up the styles from base.css
```

In development, expressing dependencies this way allows your styles to be
reloaded on the fly as you edit them. In production, all CSS files will be
concatenated into a single minified `.css` file in the build output.

You can put all your CSS right into `src/main.css`. It would still be imported
from `src/index.js`, but you could always remove that import if you later
migrate to a different build tool.

## Adding Images and Fonts

With Webpack, using static assets like images and fonts works similarly to CSS.

By requiring an image in JavaScript code, you tell Webpack to add a file to the
build of your application. The variable will contain a unique path to the
said file.

Here is an example:

```js
import logoPath from "./logo.svg"; // Tell Webpack this JS file uses this image
import { Main } from "./Main.elm";

Main.embed(
  document.getElementById("root"),
  logoPath // Pass image path as a flag for Html.programWithFlags
);
```

Later on, you can use the image path in your view for displaying it in the DOM.

```elm
view : Model -> Html Msg
view model =
    div []
        [ img [ src model.logo ] []
        , div [] [ text model.message ]
        ]
```

## Using the `public` Folder

### Changing the HTML

The `public` folder contains the HTML file so you can tweak it, for example,
to [set the page title](#changing-the-page-title).
The `<script>` tag with the compiled code will be added to it automatically
during the build process.

### Adding Assets Outside of the Module System

You can also add other assets to the `public` folder.

Note that we normally encourage you to `import` assets in JavaScript files
instead. For example, see the sections on
[adding a stylesheet](#adding-a-stylesheet) and [adding images and fonts](#adding-images-fonts-and-files).
This mechanism provides a number of benefits:

* Scripts and stylesheets get minified and bundled together to avoid extra network
  requests.
* Missing files cause compilation errors instead of 404 errors for your users.
* Result filenames include content hashes so you don’t need to worry about browsers
  caching their old versions.

However there is an **escape hatch** that you can use to add an asset outside
of the module system.

If you put a file into the `public` folder, it will **not** be processed by
Webpack. Instead it will be copied into the build folder untouched. To
reference assets in the `public` folder, you need to use a special variable
called `PUBLIC_URL`.

Inside `index.html`, you can use it like this:

```html
<link rel="shortcut icon" href="%PUBLIC_URL%/favicon.ico">
```

Only files inside the `public` folder will be accessible by `%PUBLIC_URL%`
prefix. If you need to use a file from `src` or `node_modules`, you’ll have to
copy it there to explicitly specify your intention to make this file a part of
the build.

When you run `elm-app build`, Create Elm App will substitute `%PUBLIC_URL%`
with a correct absolute path so your project works even if you use client-side
routing or host it at a non-root URL.

In Elm code, you can use `%PUBLIC_URL%` for similar purposes:

```elm
// Note: this is an escape hatch and should be used sparingly!
// Normally we recommend using `import`  and `Html.programWithFlags` for getting
// asset URLs as described in “Adding Images and Fonts” above this section.
img [ src "%PUBLIC_URL%/logo.svg" ] []
```

In JavaScript code, you can use `process.env.PUBLIC_URL` for similar purposes:

```js
const logo = `<img src=${process.env.PUBLIC_URL + "/img/logo.svg"} />`;
```

Keep in mind the downsides of this approach:

* None of the files in `public` folder get post-processed or minified.
* Missing files will not be called at compilation time, and will cause 404
  errors for your users.
* Result filenames won’t include content hashes so you’ll need to add query
  arguments or rename them every time they change.

### When to Use the `public` Folder

Normally we recommend importing [stylesheets](#adding-a-stylesheet),
[images, and fonts](#adding-images-fonts-and-files) from JavaScript.
The `public` folder is useful as a workaround for a number of less common cases:

* You need a file with a specific name in the build output, such as [`manifest.webmanifest`](https://developer.mozilla.org/en-US/docs/Web/Manifest).
* You have thousands of images and need to dynamically reference their paths.
* You want to include a small script like [`pace.js`](http://github.hubspot.com/pace/docs/welcome/)
  outside of the bundled code.
* Some library may be incompatible with Webpack and you have no other option
  but to include it as a `<script>` tag.

Note that if you add a `<script>` that declares global variables, you also need
to read the next section on using them.

## Setting up API Proxy

To forward the API ( REST ) calls to backend server, add a proxy to the
`elm-package.json` in the top level json object.

```json
{
    ...
    "proxy" : "http://localhost:1313",
    ...
}
```

Make sure the XHR requests set the `Content-type: application/json` and
`Accept: application/json`.
The development server has heuristics, to handle it's own flow, which may
interfere with proxying of other html and javascript content types.

```sh
 curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  http://localhost:3000/api/list
```

## Running Tests

Create Elm App uses [elm-test](https://github.com/rtfeldman/node-test-runner)
as its test runner. We also use cypress.io for testing UI interactions.

### Dependencies in Tests

To use packages in tests, you also need to install them in `tests` directory.

```bash
elm-app test --add-dependencies elm-package.json
```


