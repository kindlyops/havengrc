package org.kindlyops.providers.rest;

import org.keycloak.models.KeycloakSession;
import org.keycloak.services.resource.RealmResourceProvider;

public class HavenRealmResourceProvider implements RealmResourceProvider {

    private KeycloakSession session;

    public HavenRealmResourceProvider(KeycloakSession session) {
        this.session = session;
    }

    @Override
    public Object getResource() {
        return new HavenRestResource(session);
    }

    @Override
    public void close() {
    }

}