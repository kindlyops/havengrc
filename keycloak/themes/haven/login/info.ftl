<#import "template_2.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "title">
    ${message.summary}
    <#elseif section = "header">
    <h2>${message.summary}</h2>
    <#elseif section = "form">
    <div id="kc-info-message">
        <p class="instruction">${message.summary}<#if requiredActions??><#list requiredActions>: <b><#items as reqActionItem>${msg("requiredAction.${reqActionItem}")}<#sep>, </#items></b></#list><#else></#if></p>
        <#if skipLink??>
        <#else>
            <#if pageRedirectUri??>
                <p><a href="${pageRedirectUri}">${msg("backToApplication")}</a></p>
            <#elseif actionUri??>
                <p><a href="${actionUri}">${msg("proceedWithAction")}</a></p>
            <#elseif client.baseUrl??>
                <p><a href="${client.baseUrl}">${msg("backToApplication")}</a></p>
            </#if>
        </#if>
    </div>
    </#if>
</@layout.registrationLayout>
