package org.kindlyops.providers.rest;

import org.keycloak.models.KeycloakSession;
import org.keycloak.services.resource.RealmResourceProvider;

import org.keycloak.services.managers.AppAuthManager;
import org.keycloak.services.managers.AuthenticationManager;

import javax.ws.rs.ForbiddenException;
import javax.ws.rs.NotAuthorizedException;
import javax.ws.rs.Path;
import javax.ws.rs.GET;
import javax.ws.rs.Produces;

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

    @Path("organizations")
    public OrganizationResource getOrganizationResource() {
        return new OrganizationResource(session);
    }

    // Same like "companies" endpoint, but REST endpoint is authenticated with
    // Bearer token and user must be in realm role "admin"
    // Just for illustration purposes
    @Path("organizations-auth")
    public OrganizationResource getOrganizationResourceAuthenticated() {
        checkRealmAdmin();
        return new OrganizationResource(session);
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
