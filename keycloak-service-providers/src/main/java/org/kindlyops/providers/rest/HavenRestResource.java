package org.kindlyops.providers.rest;

import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.services.resource.RealmResourceProvider;

import org.keycloak.services.managers.AppAuthManager;
import org.keycloak.services.managers.AuthenticationManager;

import javax.ws.rs.ForbiddenException;
import javax.ws.rs.NotAuthorizedException;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

import org.kindlyops.providers.email.HavenEmailProvider;
import org.keycloak.theme.FreeMarkerUtil;

public class HavenRestResource {

    private final KeycloakSession session;
    private final AuthenticationManager.AuthResult auth;

    public HavenRestResource(KeycloakSession session) {
        this.session = session;
        this.auth = new AppAuthManager().authenticateBearerToken(session, session.getContext().getRealm());
    }

    @GET
    @Produces("text/plain; charset=utf-8")
    public String get() {
        String name = session.getContext().getRealm().getDisplayName();
        if (name == null) {
            name = session.getContext().getRealm().getName();
        }
        return "Hello " + name;
    }

    // REST endpoint is authenticated with
    // Bearer token and user must be in realm role "admin"
    @Path("organizations")
    public OrganizationResource getOrganizationResource() {
        checkRealmAdmin();
        return new OrganizationResource(session);
    }

    @Path("funnel/verify-email")
    @POST
    public Response verifyEmail() {
        checkRealmAdmin();
        RealmModel realm = session.getContext().getRealm();
        FreeMarkerUtil util = new FreeMarkerUtil();

        HavenEmailProvider provider = new HavenEmailProvider(session, util);
        // UserModel existingUser = // TODO get user that we need to verify from API
        // TODO figure out brokerContext and set up linkk.

        // try {
        // context.getSession().getProvider(EmailTemplateProvider.class).setRealm(realm)
        // .setAuthenticationSession(authSession).setUser(existingUser)
        // .setAttribute(EmailTemplateProvider.IDENTITY_PROVIDER_BROKER_CONTEXT,
        // brokerContext)
        // .sendConfirmIdentityBrokerLink(link, expirationInMinutes);

        // event.success();
        // } catch (EmailException e) {
        // event.error(Errors.EMAIL_SEND_FAILED);

        // ServicesLogger.LOGGER.confirmBrokerEmailFailed(e);
        // Response challenge = context.form().setError(Messages.EMAIL_SENT_ERROR)
        // .createErrorPage(Response.Status.INTERNAL_SERVER_ERROR);
        // context.failure(AuthenticationFlowError.INTERNAL_ERROR, challenge);
        // return;
        // }

        // get the Haven email template provider class that derives from
        // https://github.com/keycloak/keycloak/blob/b478472b3578b8980d7b5f1642e91e75d1e78d16/services/src/main/java/org/keycloak/email/freemarker/FreeMarkerEmailTemplateProvider.java
        // see example use at
        // https://github.com/keycloak/keycloak/blob/d04791243cd2ce3ec9203e098f96591b58019deb/services/src/main/java/org/keycloak/authentication/authenticators/broker/IdpEmailVerificationAuthenticator.java
        return Response.ok().build();
    }

    @Path("memberships")
    public MembershipResource getMembershipResource() {
        return new MembershipResource(session);
    }

    private void checkRealmAdmin() {
        if (auth == null) {
            throw new NotAuthorizedException("Bearer");
        } else if (auth.getToken().getRealmAccess() == null
                || !auth.getToken().getRealmAccess().isUserInRole("admin")) {
            throw new ForbiddenException("Does not have realm admin role");
        }
    }

}
