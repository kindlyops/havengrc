'use strict';

const fs = require("fs");
const unleash = require('unleash-server');
const enableKeycloakOauth = require('./keycloak-auth-hook');

let options = {};

options.adminAuthentication = 'custom';
options.preRouterHook = enableKeycloakOauth

if (process.env.DATABASE_URL_FILE) {
    options.databaseUrl = fs.readFileSync(process.env.DATABASE_URL_FILE);
}

unleash
    .start(options)
    .then(server => {
        console.log(
            `Unleash API started on http://localhost:${server.app.get('port')}`
        );
    });