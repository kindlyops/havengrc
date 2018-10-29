package org.kindlyops.providers.rest;

import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;

import org.keycloak.services.managers.AppAuthManager;
import org.keycloak.services.managers.AuthenticationManager;
import org.keycloak.authentication.actiontoken.idpverifyemail.IdpVerifyAccountLinkActionToken;
import org.keycloak.models.UserModel;
import org.keycloak.email.EmailException;

import javax.ws.rs.ForbiddenException;
import javax.ws.rs.NotAuthorizedException;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import java.util.concurrent.TimeUnit;

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
        // TODO get email from API call
        String email = "user1@havengrc.com";
        UserModel user = session.users().getUserByEmail(email, realm);
        FreeMarkerUtil util = new FreeMarkerUtil();

        HavenEmailProvider provider = new HavenEmailProvider(session, util);
        int seconds = realm.getActionTokenGeneratedByUserLifespan(IdpVerifyAccountLinkActionToken.TOKEN_TYPE);
        long expiration = TimeUnit.SECONDS.toMinutes(seconds);
        try {
            provider.setUser(user);
            provider.setRealm(realm);
            provider.sendFunnelVerifyEmail("http://link", expiration);
        } catch (EmailException e) {
            return Response.serverError().build();
        }
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
        return Response.ok().build();
    }

    @Path("memberships")
    public MembershipResource getMembershipResource() {
        return new MembershipResource(session);
    }

    private void checkRealmAdmin() {
        // TODO: figure out if this is the right permission check. We want the
        // permission check used for the admin api
        if (auth == null) {
            throw new NotAuthorizedException("Bearer");
        } else if (auth.getToken().getRealmAccess() == null
                || !auth.getToken().getRealmAccess().isUserInRole("admin")) {
            throw new ForbiddenException("Does not have realm admin role");
        }
    }

}
