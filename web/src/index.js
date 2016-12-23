require('./main.css');

var Elm = require('./Main.elm');

var options = {
  allowedConnections: ['Username-Password-Authentication'],
  theme: {
    logo: 'https://www.kindlyops.com/img/compliance_ops_lock_logo.png',
    primaryColor: '#5ab4ac'
  },
  languageDictionary: {
    emailInputPlaceholder: "yours@example.com",
    title: "ComplianceOps"
  },
};

if (process.env.APP_ENV === 'dev') {
  CLIENT_ID = "dLgiofn95h2SnOUllXUdaQaL5S2ShWrk"; // ComplianceOps dev id
} else {
  CLIENT_ID = "{{.Env.AUTH0_CLIENT_ID}}";
}
var CLIENT_DOMAIN = "auditproof.auth0.com";
var lock = new Auth0Lock(CLIENT_ID, CLIENT_DOMAIN, options);
var storedProfile = localStorage.getItem('profile');
var storedToken = localStorage.getItem('token');
var authData = storedProfile && storedToken ? { profile: JSON.parse(storedProfile), token: storedToken } : null;
//var elmApp = Elm.Main.fullscreen();
var elmApp = Elm.Main.embed(document.getElementById('root'), authData);

// Show Auth0 lock subscription.
console.log(elmApp);

elmApp.ports.auth0showLock.subscribe(function(opts) {
  lock.show();
});

// Log out of Auth0 subscription
elmApp.ports.auth0logout.subscribe(function(opts) {
  localStorage.removeItem('profile');
  localStorage.removeItem('token');
});

lock.on("authenticated", function(authResult) {
  lock.getProfile(authResult.idToken, function(err, profile) {
    var result = { err: null, ok: null };
    var token = authResult.idToken;

    if (!err) {
      result.ok = { profile: profile, token: token };
      localStorage.setItem('profile', JSON.stringify(profile));
      localStorage.setItem('token', token);
    } else {
      result.err = err.details;
      result.err.name = result.err.name ? result.err.name : null;
      result.err.code = result.err.code ? result.err.code : null;
      result.err.statusCode = result.err.statusCode ? result.err.statusCode : null;
    }

    elmApp.ports.auth0authResult.send(result);
  });
});
