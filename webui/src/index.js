import "./main.scss";

import { Main } from './Main.elm'

if (process.env.NODE_ENV === 'development') {
  var CLIENT_ID = process.env.ELM_APP_KEYCLOAK_CLIENT_ID
} else {
  var CLIENT_ID = '{{.Env.ELM_APP_KEYCLOAK_CLIENT_ID}}'
}
/* global Keycloak */
var keycloak = Keycloak({
  url: '/auth',
  realm: 'havendev',
  clientId: 'havendev'
})
var storedProfile = localStorage.getItem('profile')
var storedToken = localStorage.getItem('token')
var authData =
  storedProfile && storedToken
    ? { profile: JSON.parse(storedProfile), token: storedToken }
    : null

var elmApp = Main.embed(document.getElementById('root'), authData)

function sendElmKeycloakToken () {
  localStorage.setItem('profile', JSON.stringify(keycloak.profile))
  localStorage.setItem('token', keycloak.token)
  var result = { err: null, ok: null }
  result.ok = { profile: keycloak.profile, token: keycloak.token }
  elmApp.ports.keycloakAuthResult.send(result)
}

keycloak.onAuthSuccess = function () {
  keycloak
    .loadUserProfile()
    .success(sendElmKeycloakToken)
    .error(function (/* errorData */) {
      var result = { err: { name: 'unknown error' }, ok: null }
      elmApp.ports.keycloakAuthResult.send(result)
    })
}

function tellElmLogout () {
  /// alert("got keycloak logout callback");
  // send a null result to trigger our existing AuthResult code and logout.
  var result = { err: null, ok: null }
  localStorage.removeItem('profile')
  localStorage.removeItem('token')
  elmApp.ports.keycloakAuthResult.send(result)
}

keycloak.onAuthLogout = tellElmLogout

keycloak.onAuthRefreshSuccess = sendElmKeycloakToken

keycloak.onAuthRefreshError = tellElmLogout

keycloak.onTokenExpired = function () {
  console.log('got keycloak token expired')
  keycloak.updateToken(300)
}

keycloak.init()

elmApp.ports.keycloakLogin.subscribe(function () {
  keycloak.login().error(function (/* errorData */) {
    alert('failed to initialize')
    // check for error, error_description
    // https://github.com/keycloak/keycloak-js-bower/blob/master/dist/keycloak.js#L506
  })
})

// Log out of keycloak
elmApp.ports.keycloakLogout.subscribe(function () {
  localStorage.removeItem('profile')
  localStorage.removeItem('token')
  keycloak.logout()
})

// set the page title
elmApp.ports.setTitle.subscribe(function (title) {
  document.title = title
})

elmApp.ports.showError.subscribe(function (messageString) {
  console.error(messageString)
  let snackBarElement = document.getElementById('snackbar')
  snackBarElement.classList.add('show')
  let snackBarBodyElement = document.getElementById('snackbar-body')
  snackBarBodyElement.innerHTML = messageString
  setTimeout(function () {
    let snackBarElement = document.getElementById('snackbar')
    snackBarElement.classList.remove('show')
  }, 3000)
})
