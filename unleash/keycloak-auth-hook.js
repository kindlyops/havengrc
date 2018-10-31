const { User, AuthenticationRequired } = require('unleash-server');
const passport = require('passport');
const KeycloakStrategy = require('@exlinc/keycloak-passport');

// Register the strategy with passport
passport.use(
    "keycloak",
    new KeycloakStrategy(
        {
            host: process.env.KEYCLOAK_HOST,
            realm: process.env.KEYCLOAK_REALM,
            clientID: process.env.KEYCLOAK_CLIENT_ID,
            clientSecret: process.env.KEYCLOAK_CLIENT_SECRET,
            callbackURL: `/unleash/api/auth/callback`,
            authorizationURL: `${process.env.KEYCLOAK_HOST}/auth/realms/${process.env.KEYCLOAK_REALM}/protocol/openid-connect/auth`,
            // TODO: sort out what hostname to use from inside the container to solve
            // the issuer mismatch problem.
            // data: '{"error":"invalid_token","error_description":"Token invalid: Invalid token issuer. Expected \'http://keycloak:8080/auth/realms/havendev\', but was \'http://localhost:2015/auth/realms/havendev\'"}' }
            tokenURL: `http://keycloak:8080/auth/realms/${process.env.KEYCLOAK_REALM}/protocol/openid-connect/token`,
            userInfoURL: `http://keycloak:8080/auth/realms/${process.env.KEYCLOAK_REALM}/protocol/openid-connect/userinfo`
        },
        (accessToken, refreshToken, profile, done) => {
            // This is called after a successful authentication has been completed
            // Here's a sample of what you can then do, i.e., write the user to your DB
            // User.findOrCreate({ email: profile.email }, (err, user) => {
            //     assert.ifError(err);
            //     user.keycloakId = profile.keycloakId;
            //     user.imageUrl = profile.avatar;
            //     user.name = profile.name;
            //     user.save((err, savedUser) => done(err, savedUser));
            // });
        }
    )
);

function enableKeycloakOauth(app) {
    app.use(passport.initialize());
    app.use(passport.session());

    passport.serializeUser((user, done) => done(null, user));
    passport.deserializeUser((user, done) => done(null, user));
    app.get('/api/admin/login', passport.authenticate('keycloak'));

    app.get(
        '/api/auth/callback',
        passport.authenticate('keycloak', {
            failureRedirect: '/unleash/api/admin/error-login',
        }),
        (req, res) => {
            // Successful authentication, redirect to your app.
            res.redirect('/');
        }
    );

    app.use('/api/admin/', (req, res, next) => {
        if (req.user) {
            next();
        } else {
            // Instruct unleash-frontend to pop-up auth dialog
            return res
                .status('401')
                .json(
                    new AuthenticationRequired({
                        path: '/unleash/api/admin/login',
                        type: 'custom',
                        message: `You have to identify yourself in order to use Unleash. 
                        Click the button and follow the instructions.`,
                    })
                )
                .end();
        }
    });
}

module.exports = enableKeycloakOauth;