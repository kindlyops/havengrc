import './main.scss';
import { Main } from './Main.elm';

if (process.env.NODE_ENV === 'development') {
  var CLIENT_ID = process.env.ELM_APP_KEYCLOAK_CLIENT_ID;
} else {
  var CLIENT_ID = "{{.Env.ELM_APP_KEYCLOAK_CLIENT_ID}}";
}
/*global Keycloak*/
var keycloak = Keycloak({
    url: '/auth', // TODO: try full url for ngrok, client matching uses url
    realm: 'havendev',
    clientId: CLIENT_ID
});
var storedProfile = localStorage.getItem('profile');
var storedToken = localStorage.getItem('token');
var authData = storedProfile && storedToken ? { profile: JSON.parse(storedProfile), token: storedToken } : null;

var elmApp = Main.embed(document.getElementById('root'), authData);

keycloak.init();

document.arrive(".mdc-textfield", function(){
  window.mdc.autoInit(document, () => { });
});

document.arrive("#MenuButton", function(){
  let drawer = new mdc.drawer.MDCPersistentDrawer(document.getElementById('MenuDrawer'));
  document.getElementById('MenuButton').addEventListener('click', function () {
    drawer.open = !drawer.open;
  });
});

document.arrive("#UserDropdownMenu", function(){
  let menu = new mdc.menu.MDCSimpleMenu(document.getElementById('UserDropdownMenu'));
  document.getElementById('UserDropdownButton').addEventListener('click', () => menu.open = !menu.open);
});



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
    }).error(function(/*errorData*/) {
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

elmApp.ports.keycloakShowLock.subscribe(function() {
  console.log("calling login");
  keycloak.login().error(function(/*errorData*/) {
    alert('failed to initialize'); // TODO polish this error case
    // check for error, error_description
    // https://github.com/keycloak/keycloak-js-bower/blob/master/dist/keycloak.js#L506
  });
});

// Log out of keycloak
elmApp.ports.keycloakLogout.subscribe(function() {
  localStorage.removeItem('profile');
  localStorage.removeItem('token');
  keycloak.logout();
});

// set the page title
elmApp.ports.setTitle.subscribe(function(title) {
  document.title = title;
});