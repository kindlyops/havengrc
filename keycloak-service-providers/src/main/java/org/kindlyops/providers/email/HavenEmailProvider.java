package org.kindlyops.providers.email;

import java.util.HashMap;
import java.util.Map;
import org.keycloak.email.EmailException;
import org.keycloak.email.freemarker.beans.ProfileBean;
import org.keycloak.events.Errors;
import org.keycloak.events.EventBuilder;
import org.keycloak.events.EventType;

import org.keycloak.email.freemarker.FreeMarkerEmailTemplateProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.theme.FreeMarkerUtil;

public class HavenEmailProvider extends FreeMarkerEmailTemplateProvider {

    public HavenEmailProvider(KeycloakSession session, FreeMarkerUtil freeMarker) {
        super(session, freeMarker);
    }

    public void sendFunnelVerifyEmail(String link, long expirationInMinutes) throws EmailException {
        Map<String, Object> attributes = new HashMap<String, Object>(this.attributes);
        attributes.put("user", new ProfileBean(user));
        addLinkInfoIntoAttributes(link, expirationInMinutes, attributes);

        attributes.put("realmName", getRealmName());

        send("emailFunnelVerificationSubject", "email-funnel-verification.ftl", attributes);
    }

};
