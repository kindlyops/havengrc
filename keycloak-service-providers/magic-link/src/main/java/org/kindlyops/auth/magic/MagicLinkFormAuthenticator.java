/*
 * Copyright 2016 Red Hat, Inc. and/or its affiliates
 * and other contributors as indicated by the @author tags.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.kindlyops.auth.magic;

import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.AuthenticationFlowError;
import org.keycloak.authentication.Authenticator;
import org.keycloak.authentication.authenticators.browser.AbstractUsernameFormAuthenticator;
import org.keycloak.common.util.KeycloakUriBuilder;
import org.keycloak.email.EmailException;
import org.keycloak.email.EmailSenderProvider;
import org.keycloak.events.Errors;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.models.utils.KeycloakModelUtils;
import org.keycloak.sessions.RootAuthenticationSessionModel;

import javax.ws.rs.core.MultivaluedMap;

/**
 * @author <a href="mailto:sthorger@redhat.com">Stian Thorgersen</a>
 */
public class MagicLinkFormAuthenticator extends AbstractUsernameFormAuthenticator implements Authenticator {

    @Override
    public void action(AuthenticationFlowContext context) {
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        String email = formData.getFirst("email");
        String sessionId = context.getHttpRequest().getUri().getQueryParameters().getFirst("auth_session_id");
        UserModel user = context.getSession().users().getUserByEmail(email, context.getRealm());
        if (user == null) {
            context.getEvent().error(Errors.USER_NOT_FOUND);
            context.failure(AuthenticationFlowError.INVALID_CREDENTIALS);
            return;

            // Uncomment the following line to require user to update profile on first login
            // user.addRequiredAction(UserModel.RequiredAction.UPDATE_PROFILE);
        }

        String key = KeycloakModelUtils.generateId();
        context.getAuthenticationSession().setAuthNote("email-key", key);
        String link = "";
        if ("none".equals(sessionId)) {
            RootAuthenticationSessionModel rootAuthSession = context.getSession().authenticationSessions()
                    .createRootAuthenticationSession(context.getRealm());
            link = KeycloakUriBuilder.fromUri(context.getRefreshExecutionUrl()).queryParam("key", key)
                    .queryParam("auth_session_id", rootAuthSession.getId()).build().toString();
        } else {
            link = KeycloakUriBuilder.fromUri(context.getRefreshExecutionUrl()).queryParam("key", key).build()
                    .toString();
        }

        String body = "<a href=\"" + link + "\">Click to login</a>";
        try {
            context.getSession().getProvider(EmailSenderProvider.class).send(context.getRealm().getSmtpConfig(), user,
                    "Login link", null, body);
        } catch (EmailException e) {
            e.printStackTrace();
        }

        context.setUser(user);
        context.challenge(context.form().createForm("view-email.ftl"));
    }

    @Override
    public void authenticate(AuthenticationFlowContext context) {
        String sessionKey = context.getAuthenticationSession().getAuthNote("email-key");
        if (sessionKey != null) {
            String requestKey = context.getHttpRequest().getUri().getQueryParameters().getFirst("key");
            UserModel user = context.getUser();
            // Check if email is verified.
            if (!user.isEmailVerified()) {
                user.setEmailVerified(true);
            }
            if (requestKey != null) {
                if (requestKey.equals(sessionKey)) {
                    context.getUser().removeRequiredAction("terms_and_conditions");
                    context.success();
                } else {
                    context.failure(AuthenticationFlowError.INVALID_CREDENTIALS);
                }
            } else {
                context.challenge(context.form().createForm("view-email.ftl"));
            }
        } else {
            context.challenge(context.form().createForm("login-email-only.ftl"));
        }
    }

    @Override
    public boolean requiresUser() {
        return false;
    }

    @Override
    public boolean configuredFor(KeycloakSession session, RealmModel realm, UserModel user) {
        return true;
    }

    @Override
    public void setRequiredActions(KeycloakSession session, RealmModel realm, UserModel user) {
        // Intentionally blank
    }

    @Override
    public void close() {
        // Intentionally blank
    }

}
