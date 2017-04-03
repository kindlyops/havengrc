# Haven GRC

## quick start

You need to have docker available.

```sh
npm install
make run
```

### Safety at speed
By connecting activities to policies to values & customer requirements, we help organizations avoid getting bogged down in rules that no longer make sense, and empower people to update practices to use modern tools and techniques without abandoning responsible oversight and administrative controls.

### Design & Documention
[Design ideas](https://paper.dropbox.com/doc/Design-Ideas-IM45aAXQEvSZWd1cqNJ4p)

This project was bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app) and then ejected.

## Learning Elm

Why use Elm? Elm is both a framework and a language. Here is an excellent 16
minute video by Richard Feldman that explains the framework architecture choices
that Elm makes compared to jQuery and Flux. [From jQuery to Flux to Elm](https://www.youtube.com/watch?v=NgwQHGqIMbw).

Elm is also a language that compiles to javascript. Here are some resources for
learning Elm. In particular, the DailyDrip course is very very good, and provides
several wonderful example applications that are MIT licensed and have been used
to help bootstrap this application. You should subscribe to DailyDrip and support
their work.

 * Free elm course http://courses.knowthen.com/p/elm-for-beginners
 * Daily Drip elm course that sends you a little bit of code each day to work on https://www.dailydrip.com/topics/elm
 * Pragmatic Programmers course https://pragmaticstudio.com/elm
 * Frontend Masters 2-day elm workshop https://frontendmasters.com/workshops/elm/

## Installing Elm packages

```sh
elm-package install <package-name>
```

## Available scripts
In the project directory you can run:
### `make build`
Builds the app for production to the `dist` folder.  

The build is minified and the filenames include the hashes.  
Your app is ready to be deployed!

### `make run`
Runs the app in the development mode.  
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.  
You will also see any lint errors in the console.

### `make test`
Run tests with [node-test-runner](https://github.com/rtfeldman/node-test-runner/tree/master)
