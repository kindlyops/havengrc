'use strict';

const fs = require("fs");
const express = require("express");
const unleash = require('unleash-server');

let options = {};

options.adminAuthentication = 'custom';
function gatekeeperAuthentication(app) {
    app.use('/api/admin/', (req, res, next) => {
        const email = req.get('X-Auth-Email');

        if (email) {
            // TODO: need to do some verification of credentials here, probably
            // validate X-Auth-Token signature

            const user = new unleash.User({ email: `${email}` });
            req.user = user;
            next();
        } else {
            return res
                .status('401')
                .end('access denied');
        }
    });

    app.use((req, res, next) => {
        // Updates active sessions every hour
        req.session.nowInHours = Math.floor(Date.now() / 3600e3);
        next();
    });
};
options.preRouterHook = gatekeeperAuthentication;


function serveFrontend(app) {
    app.use('/', express.static('/frontend'));
}

options.preHook = serveFrontend;

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
