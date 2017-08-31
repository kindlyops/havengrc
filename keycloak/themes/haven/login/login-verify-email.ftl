<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
        ${msg("emailVerifyTitle")}
    <#elseif section = "header">
        <h2>${msg("emailVerifyTitle")}</h2>
    <#elseif section = "form">
    <div class="mdc-layout-grid__cell--span-12 align-center">
        <p class="instruction">
            ${msg("emailVerifyInstruction1")}
        </p>
        <p class="instruction">
            ${msg("emailVerifyInstruction2")} <a href="${url.loginAction}">${msg("doClickHere")}</a> ${msg("emailVerifyInstruction3")}
        </p>
    </div>
    </#if>
</@layout.registrationLayout>
