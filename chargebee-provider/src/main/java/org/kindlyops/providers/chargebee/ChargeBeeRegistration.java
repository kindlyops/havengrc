package org.kindlyops.providers.chargebee;

import org.apache.commons.lang.StringUtils;
import org.keycloak.Config;

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
import org.keycloak.models.AuthenticatorConfigModel;
import org.keycloak.provider.ConfiguredProvider;
import org.keycloak.models.utils.FormMessage;

import com.chargebee.*;
import com.chargebee.Environment;
import com.chargebee.models.HostedPage;

import javax.ws.rs.core.MultivaluedMap;
import java.util.ArrayList;
import java.util.List;

import org.jboss.logging.Logger;

public class ChargeBeeRegistration implements FormAction, FormActionFactory, ConfiguredProvider {
    private static String FIELD_ORGANIZATION = "user.attributes.organization";
    private static String ATTRIBUTE_ORGANIZATION = "organization";
    public static final String API_KEY = "api.key";
    public static final String PLAN_ID = "plan.id";
    public static final String SITE_NAME = "site.name";
    private static Requirement[] REQUIREMENT_CHOICES = {
            Requirement.REQUIRED,
            Requirement.DISABLED
    };
    private static final Logger LOG = Logger.getLogger(ChargeBeeRegistration.class);
    private static final ChargeBeeRegistration SINGLETON = new ChargeBeeRegistration();

    public ChargeBeeRegistration() {

    }

    public String getDisplayType() {
        return "ChargeBee Integration";
    }

    public String getReferenceCategory() {
        return null;
    }

    public boolean isConfigurable() {
        return true;
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

    @Override
    public void buildPage(FormContext context, LoginFormsProvider form) {
        AuthenticatorConfigModel chargebeeConfig = context.getAuthenticatorConfig();
        if (chargebeeConfig == null || chargebeeConfig.getConfig() == null
                || chargebeeConfig.getConfig().get(API_KEY) == null
                || chargebeeConfig.getConfig().get(PLAN_ID) == null
                || chargebeeConfig.getConfig().get(SITE_NAME) == null
                ) {
            form.addError(new FormMessage(null, "Chargebee not configured."));
            return;
        }
        String apiKey = chargebeeConfig.getConfig().get(API_KEY);
        String planID = chargebeeConfig.getConfig().get(PLAN_ID);
        String siteName = chargebeeConfig.getConfig().get(SITE_NAME);
        Environment.configure(siteName,apiKey);
        Result finalResult;
        try {
            finalResult = HostedPage.checkoutNew()
                .subscriptionPlanId(planID)
                .billingAddressCountry("US").request();

        } catch (Exception e) {
            LOG.errorv("chargebeeSPI ERROR caused by: <{0}>", e);
            return;
        }
        LOG.info("chargebeeSPI: buildPage called");
        HostedPage hostedPage = finalResult.hostedPage();
        form.setAttribute("pageId", hostedPage.id());
        form.setAttribute("pageUrl", hostedPage.url());
        form.setAttribute("siteName", siteName);
    }

    @Override
    public void validate(ValidationContext context) {
        MultivaluedMap formData = context.getHttpRequest().getDecodedFormParameters();
        ArrayList errors = new ArrayList();
        // Check for users with the organization already.
        // TODO should be smarter than this.
        LOG.info("chargebeeSPI: validating");
        List users = context.getSession().users().searchForUserByUserAttribute(ATTRIBUTE_ORGANIZATION,FIELD_ORGANIZATION, context.getRealm());
        if (users.size() > 0) {
            context.validationError(formData, errors);
        } else {
            context.success();
        }
    }

    @Override
    public void success(FormContext context) {

        UserModel user = context.getUser();
        MultivaluedMap formData = context.getHttpRequest().getDecodedFormParameters();
        String org = formData.getFirst(FIELD_ORGANIZATION).toString();

        if (!StringUtils.isBlank(org)) {
            user.setSingleAttribute("organization", org);
        }
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
        LOG.warnv("chargebeeSPI: getHelpText called <{0}>", this);
        return "ChargeBee Registration";

    }

    public FormAction create(KeycloakSession session) {
        return SINGLETON;
    }

    public void init(Config.Scope config) {
    }

    public void postInit(KeycloakSessionFactory factory) {
    }

    private static final List<ProviderConfigProperty> configProperties = new ArrayList<ProviderConfigProperty>();

    static {
        ProviderConfigProperty property;
        property = new ProviderConfigProperty();
        property.setName(API_KEY);
        property.setLabel("Chargebee API Key");
        property.setType(ProviderConfigProperty.STRING_TYPE);
        property.setHelpText("Chargebee API Key");
        configProperties.add(property);
        property = new ProviderConfigProperty();
        property.setName(PLAN_ID);
        property.setLabel("Chargebee Plan ID");
        property.setType(ProviderConfigProperty.STRING_TYPE);
        property.setHelpText("Chargebee Plan ID");
        configProperties.add(property);
        property = new ProviderConfigProperty();
        property.setName(SITE_NAME);
        property.setLabel("Chargebee Site Name");
        property.setType(ProviderConfigProperty.STRING_TYPE);
        property.setHelpText("The custom subdomain for your Chargebee site");
        configProperties.add(property);
    }

    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        return configProperties;
    }

}
