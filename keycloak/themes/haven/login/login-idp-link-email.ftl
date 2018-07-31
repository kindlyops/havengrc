<#import "template_2.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        <h2>${msg("emailLinkIdpTitle", idpAlias)}</h2>
    <#elseif section = "form">
      <div class="col-lg-7 mx-auto pt-2 text-center email-verify-box">
        <p id="instruction1" class="instruction">
            ${msg("emailLinkIdp1", idpAlias, brokerContext.username, realm.displayName)}
        </p>
        <p id="instruction2" class="instruction">
            ${msg("emailLinkIdp2")} <a href="${url.loginAction}">${msg("doClickHere")}</a> ${msg("emailLinkIdp3")}
        </p>
        <p id="instruction3" class="instruction">
            ${msg("emailLinkIdp4")} <a href="${url.loginAction}">${msg("doClickHere")}</a> ${msg("emailLinkIdp5")}
        </p>
      </div>
    </#if>
</@layout.registrationLayout>
