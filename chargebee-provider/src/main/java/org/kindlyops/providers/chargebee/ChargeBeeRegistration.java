package org.kindlyops.providers.chargebee;

import org.apache.commons.lang.StringUtils;
import org.keycloak.Config.Scope;
import org.keycloak.authentication.FormAction;
import org.keycloak.authentication.FormActionFactory;
import org.keycloak.authentication.FormContext;
import org.keycloak.authentication.ValidationContext;
import org.keycloak.forms.login.LoginFormsProvider;
import org.keycloak.models.AuthenticationExecutionModel.Requirement;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.provider.ProviderConfigProperty;


import javax.ws.rs.core.MultivaluedMap;
import java.util.ArrayList;
import java.util.List;

public class ChargeBeeRegistration implements FormAction, FormActionFactory {
    private static String FIELD_ORGANIZATION = "user.attributes.organization";
    private static String ATTRIBUTE_ORGANIZATION = "organization";
    private static Requirement[] REQUIREMENT_CHOICES;

    public ChargeBeeRegistration() {

    }

    public String getDisplayType() {
        return "ChargeBee Integration";
    }

    public String getReferenceCategory() {
        return null;
    }

    public boolean isConfigurable() {
        return false;
    }

    public Requirement[] getRequirementChoices() {
        return REQUIREMENT_CHOICES;
    }

    public boolean isUserSetupAllowed() {
        return false;
    }
    public void setRequiredActions(KeycloakSession session, RealmModel realm, UserModel user) {
    }

    public String getId() {
        return "chargebee-registration";
    }

    public void buildPage(FormContext context, LoginFormsProvider form) {
    }

    public void validate(ValidationContext context) {
        MultivaluedMap formData = context.getHttpRequest().getDecodedFormParameters();
        ArrayList errors = new ArrayList();
        // Check for users with the organization already.
        // TODO should be smarter than this.
        List users = context.getSession().users().searchForUserByUserAttribute(ATTRIBUTE_ORGANIZATION,FIELD_ORGANIZATION, context.getRealm());
        if (users.size() > 0) {
            context.validationError(formData, errors);
        } else {
            context.success();
        }
    }

    public void success(FormContext context) {

        UserModel user = context.getUser();
        MultivaluedMap formData = context.getHttpRequest().getDecodedFormParameters();
        String org = formData.getFirst(FIELD_ORGANIZATION).toString();

        if (!StringUtils.isBlank(org)) {
            user.setSingleAttribute("organization", org);
        }
    }

    public List<ProviderConfigProperty> getConfigProperties() {
        return null;
    }

    public boolean requiresUser() {
        return false;
    }

    public void close() {
    }

    public boolean configuredFor(KeycloakSession session, RealmModel realm, UserModel user) {
        return true;
    }

    public String getHelpText() {
        return "ChargeBee Registration";
    }

    public FormAction create(KeycloakSession session) {
        return this;
    }

    public void init(Scope config) {
    }

    public void postInit(KeycloakSessionFactory factory) {
    }
}