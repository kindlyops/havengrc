<#import "template_2.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        <h2>${msg("confirmLinkIdpTitle")}</h2>
    <#elseif section = "form">
        <form id="kc-register-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
          <div class="form-row justify-content-center">
            <button type="submit" class="btn btn-secondary" name="submitAction" id="updateProfile" value="updateProfile">${msg("confirmLinkIdpReviewProfile")}</button>
            <button type="submit" class="btn btn-default" name="submitAction" id="linkAccount" value="linkAccount">${msg("confirmLinkIdpContinue", idpAlias)}</button>
          </div>
        </form>
    </#if>
</@layout.registrationLayout>
