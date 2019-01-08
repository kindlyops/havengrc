import "./main.scss";

import { Elm } from './Main.elm'

if (process.env.NODE_ENV === 'development') {
  var CLIENT_ID = process.env.ELM_APP_KEYCLOAK_CLIENT_ID
} else {
  var CLIENT_ID = '{{.Env.ELM_APP_KEYCLOAK_CLIENT_ID}}'
}
// var storedProfile = sessionStorage.getItem('profile')
// var storedToken = sessionStorage.getItem('token')
var storedSurveyState = sessionStorage.getItem('storedSurvey')
var authData =
  storedProfile && storedToken
    ? { profile: JSON.parse(storedProfile), token: storedToken }
    : null

var initialData = {
  // profile: authData ? authData.profile : null,
  // token: authData ? authData.token : null,
  storedSurvey: storedSurveyState ? JSON.parse(storedSurveyState) : null
}

// function sendElmKeycloakToken() {
//   sessionStorage.setItem('profile', JSON.stringify(keycloak.profile))
//   sessionStorage.setItem('token', keycloak.token)
//   var result = { err: null, ok: null }
//   result.ok = { profile: keycloak.profile, token: keycloak.token }
//   elmApp.ports.keycloakAuthResult.send(result)
// }

/* global Keycloak */
// var keycloak = Keycloak({
//   url: '/auth',
//   realm: 'havendev',
//   clientId: 'havendev'
// })

// keycloak.onAuthSuccess = function () {
//   keycloak
//     .loadUserProfile()
//     .success(sendElmKeycloakToken)
//     .error(function (/* errorData */) {
//       var result = { err: { name: 'unknown error' }, ok: null }
//       elmApp.ports.keycloakAuthResult.send(result)
//     })
// }

// keycloak.onAuthLogout = function () {
//   console.log("got onAuthLogout callback");
//   // send a null result to trigger our existing AuthResult code and logout.
//   var result = { err: null, ok: null }
//   sessionStorage.removeItem('profile')
//   sessionStorage.removeItem('token')
//   sessionStorage.removeItem('storedSurvey')
//   elmApp.ports.keycloakAuthResult.send(result)
// }

// keycloak.onAuthRefreshSuccess = sendElmKeycloakToken

// keycloak.onAuthRefreshError = function () {
//   console.log("got AuthRefreshError callback");
//   // send a null result to trigger our existing AuthResult code and logout.
//   var result = { err: null, ok: null }
//   sessionStorage.removeItem('profile')
//   sessionStorage.removeItem('token')
//   elmApp.ports.keycloakAuthResult.send(result)
// }

// keycloak.onTokenExpired = function () {
//   console.log('got keycloak token expired')
//   keycloak.updateToken(300)
// }

// keycloak.init({ onLoad: 'check-sso', checkLoginIframe: false })

document.arrive("#lottie", () => {
  var element = document.getElementById('lottie');
  var animationPath = process.env.PUBLIC_URL + '/animations/haven-demo.json'
  if (element) {
    console.log("got lottie element");
    lottie.setLocationHref(document.location.href)
    lottie.loadAnimation({
      container: element, // Required
      path: animationPath, // Required
      renderer: 'svg', // Required
      loop: true, // Optional
      autoplay: true, // Optional
    });
  }
});

var elmApp = Elm.Main.init({
  node: document.getElementById('elm'),
  flags: initialData
});

// elmApp.ports.keycloakLogin.subscribe(function () {
//   keycloak.login().error(function (/* errorData */) {
//     alert('failed to initialize')
//     // check for error, error_description
//     // https://github.com/keycloak/keycloak-js-bower/blob/master/dist/keycloak.js#L506
//   })
// })

// Log out of keycloak
// elmApp.ports.keycloakLogout.subscribe(function () {
//   sessionStorage.removeItem('profile')
//   sessionStorage.removeItem('token')
//   sessionStorage.removeItem('storedSurvey')
//   keycloak.logout()
// })

elmApp.ports.radarChart.subscribe(chartConfig => {
  chartConfig.type = 'radar'
  window.myRadar = new Chart(document.getElementById('chart'), chartConfig)
})

elmApp.ports.saveSurveyState.subscribe(storedSurvey => {
  sessionStorage.setItem('storedSurvey', JSON.stringify(storedSurvey));
})

let updateChart = function (spec) {
  //console.log("updateChart was called");
  window.requestAnimationFrame(() => {
    var element = $('#vis');
    if (element) {
      vegaEmbed("#vis", spec, { actions: false }).catch(console.warn);
    }
  });
}

elmApp.ports.renderVega.subscribe(updateChart);
