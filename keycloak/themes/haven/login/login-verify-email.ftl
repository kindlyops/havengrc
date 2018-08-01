<#import "template_2.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
        ${msg("emailVerifyTitle")}
    <#elseif section = "header">
        <h2>${msg("emailVerifyTitle")}</h2>
    <#elseif section = "form">
    <div class="col-lg-7 mx-auto pt-2 text-center email-verify-box">
        <p class="instruction">
            ${msg("emailVerifyInstruction1")}
        </p>
        <p class="instruction">
            ${msg("emailVerifyInstruction2")} <a href="${url.loginAction}">${msg("doClickHere")}</a> ${msg("emailVerifyInstruction3")}
        </p>
    </div>
    </#if>
</@layout.registrationLayout>
