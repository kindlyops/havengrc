require('./main.css');

var Elm = require('./Main.elm');

if (process.env.APP_ENV === 'dev') {
  CLIENT_ID = process.env.AUTH0_CLIENT_ID; // HavenGRC dev id
} else {
  CLIENT_ID = "{{.Env.AUTH0_CLIENT_ID}}"; // TODO rename from Auth0 to keycloak
}
var keycloak = Keycloak({
    url: '/auth',
    realm: 'haven',
    clientId: CLIENT_ID
});
var storedProfile = localStorage.getItem('profile');
var storedToken = localStorage.getItem('token');
var authData = storedProfile && storedToken ? { profile: JSON.parse(storedProfile), token: storedToken } : null;
var elmApp = Elm.Main.embed(document.getElementById('root'), authData);

options = { onLoad: 'login-required', redirect_uri: 'http://localhost:2015/' };
keycloak.init(options).success(function(authenticated) {
  if (authenticated) {
    keycloak.loadUserProfile().success(function() {
          console.log(keycloak.profile);
          localStorage.setItem('profile', JSON.stringify(keycloak.profile));
          localStorage.setItem('token', keycloak.token);
      }).error(function() {
          result.err = { name: "unknown error" };
      });
    //elmApp.ports.auth0authResult.send(result);
  } else {
    alert('authentication failed'); // TODO polish
  }
}).error(function() {
  alert('failed to initialize'); // TODO polish this error case
});


// Log out of keycloak
elmApp.ports.auth0logout.subscribe(function(opts) {
  localStorage.removeItem('profile');
  localStorage.removeItem('token');
  keycloak.logout();
});
