require('./main.scss');

var Elm = require('./Main.elm');

if (process.env.APP_ENV === 'dev') {
  CLIENT_ID = process.env.KEYCLOAK_CLIENT_ID;
} else {
  CLIENT_ID = "{{.Env.KEYCLOAK_CLIENT_ID}}";
}
var keycloak = Keycloak({
    url: '/auth',
    realm: 'havendev',
    clientId: CLIENT_ID
});
var storedProfile = localStorage.getItem('profile');
var storedToken = localStorage.getItem('token');
var authData = storedProfile && storedToken ? { profile: JSON.parse(storedProfile), token: storedToken } : null;

window.addEventListener('WebComponentsReady', function() {
  // At this point we are guaranteed that all required polyfills have loaded,
  // all HTML imports have loaded, and all defined custom elements have upgraded

  // We delay Elm.Main.embed because of a problem with flickering caused by elm
  // emitting webcomponent tags before the webcomponent system is ready.
  // unrecognized tags are simply rendered as an empty div by browers.
  var elmApp = Elm.Main.embed(document.getElementById('root'), authData);

  keycloak.init();

  keycloak.onAuthSuccess = function() {
    console.log("success from keycloak login");
    var result = { err: null, ok: null };
    keycloak.loadUserProfile().success(function() {
          console.log("success from keycloak.loadUserProfile");
          console.log(keycloak.profile);
          localStorage.setItem('profile', JSON.stringify(keycloak.profile));
          localStorage.setItem('token', keycloak.token);
          result.ok = { profile: keycloak.profile, token: keycloak.token };
          console.log("sending result ");
          console.log(result);
          elmApp.ports.keycloakAuthResult.send(result);
      }).error(function(errorData) {
          result.err = { name: "unknown error" };
          // check for error, error_description
          // https://github.com/keycloak/keycloak-js-bower/blob/master/dist/keycloak.js#L506
          elmApp.ports.keycloakAuthResult.send(result);
    });
  };

  keycloak.onAuthLogout = function() {
    ///alert("got keycloak logout callback");
    // send a null result to trigger our existing AuthResult code and logout.
    var result = { err: null, ok: null };
    localStorage.removeItem('profile');
    localStorage.removeItem('token');
    elmApp.ports.keycloakAuthResult.send(result);

  };

  keycloak.onTokenExpired = function() {
    // TODO: the initial token we get expires in 5 minutes (300 seconds)
    // need to wire up token refresh based on user activity in the app.
    //alert("got keycloak token expired");
    //elmApp.ports.keycloakLogoutHappened.send();
  };

  elmApp.ports.keycloakShowLock.subscribe(function(opts) {
    console.log("calling login");
    keycloak.login().error(function(errorData) {
      alert('failed to initialize'); // TODO polish this error case
      // check for error, error_description
      // https://github.com/keycloak/keycloak-js-bower/blob/master/dist/keycloak.js#L506
    });
  });

  // Log out of keycloak
  elmApp.ports.keycloakLogout.subscribe(function(opts) {
    localStorage.removeItem('profile');
    localStorage.removeItem('token');
    keycloak.logout();
  });

  // set the page title
  elmApp.ports.setTitle.subscribe(function(title) {
    document.title = title;
  });

});
