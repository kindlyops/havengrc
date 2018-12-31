<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        <h2 class="mt-5">${msg("termsTitle")}</h2>
    <#elseif section = "form">
    <div id="kc-terms-text" class="col-10 mx-auto text-center">
        <p>${msg("termsText")?no_esc}</p>
    </div>
    <form class="col-sm-10 text-center" action="${url.loginAction}" method="POST">
        <input role="button" class="btn btn-secondary" name="accept" id="kc-accept" type="submit" value="${msg("doAccept")}"/>
        <input role="button" class="btn btn-default" name="cancel" id="kc-decline" type="submit" value="${msg("doDecline")}"/>
    </form>
    <div class="clearfix"></div>
    </#if>
</@layout.registrationLayout>
