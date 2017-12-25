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

document.arrive(".mdc-textfield", function(){
  window.mdc.autoInit(document, () => { });
});

document.arrive(".nav-flex .mdc-list-item", function(element) {
  element.addEventListener('click', function() {
    let drawer = new mdc.drawer.MDCPersistentDrawer(document.getElementById('MenuDrawer'));
    drawer.open = false;

    let menu = new mdc.menu.MDCSimpleMenu(document.getElementById('UserDropdownMenu'));
    menu.open = false;
  });
});

document.arrive("#MenuButton", function(){
  var menuDrawerElement = document.getElementById('MenuDrawer');
  let drawer = new mdc.drawer.MDCPersistentDrawer(menuDrawerElement);
  let menu = new mdc.menu.MDCSimpleMenu(document.getElementById('UserDropdownMenu'));
  document.getElementById('MenuButton').addEventListener('click', function (e) {
    drawer.open = !menuDrawerElement.classList.contains('mdc-persistent-drawer--open');
    menu.open = false;
    e.stopPropagation();
  });
});

document.arrive("#UserDropdownMenu", function(){
  let userMenuElement = document.getElementById('UserDropdownMenu');
  let menu = new mdc.menu.MDCSimpleMenu(userMenuElement);
  document.getElementById('UserDropdownButton').addEventListener('click', function (e) {
    menu.open = !userMenuElement.classList.contains('mdc-simple-menu--open');
    e.stopPropagation();
  });
});

document.addEventListener('click', function(e){
  let drawer = new mdc.drawer.MDCPersistentDrawer(document.getElementById('MenuDrawer'));
  if (drawer.open) {
    drawer.open = false;
  };

  let menu = new mdc.menu.MDCSimpleMenu(document.getElementById('UserDropdownMenu'));
  if (menu.open) {
    menu.open = false;
  };
});


function sendElmKeycloakToken() {
  localStorage.setItem('profile', JSON.stringify(keycloak.profile));
  localStorage.setItem('token', keycloak.token);
  var result = { err: null, ok: null };
  result.ok = { profile: keycloak.profile, token: keycloak.token };
  elmApp.ports.keycloakAuthResult.send(result);
}


keycloak.onAuthSuccess = function() {
  keycloak.loadUserProfile().success(sendElmKeycloakToken).error(function(/*errorData*/) {
    var result = { err: { name: "unknown error" }, ok: null };
    // TODO check for error, error_description
    // https://github.com/keycloak/keycloak-js-bower/blob/master/dist/keycloak.js#L506
    elmApp.ports.keycloakAuthResult.send(result);
  });
};

function tellElmLogout() {
  ///alert("got keycloak logout callback");
  // send a null result to trigger our existing AuthResult code and logout.
  var result = { err: null, ok: null };
  localStorage.removeItem('profile');
  localStorage.removeItem('token');
  elmApp.ports.keycloakAuthResult.send(result);

};

keycloak.onAuthLogout = tellElmLogout;

keycloak.onAuthRefreshSuccess = sendElmKeycloakToken;

keycloak.onAuthRefreshError = tellElmLogout;

keycloak.onTokenExpired = function() {
  console.log("got keycloak token expired");
  keycloak.updateToken(300);
};

keycloak.init();

elmApp.ports.keycloakLogin.subscribe(function() {
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

elmApp.ports.showError.subscribe(function(messageString) {
  let item = document.querySelector('.mdc-snackbar');
  if (item) {
    let snack = mdc.snackbar.MDCSnackbar.attachTo(item);
    snack.show({ message: messageString });
  }
});
