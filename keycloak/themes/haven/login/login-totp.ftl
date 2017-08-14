<#import "template_2.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
        ${msg("loginTitle",realm.displayName)}
    <#elseif section = "header">
        <h1>${msg("loginTitleHtml",realm.displayNameHtml)}</h1>
    <#elseif section = "form">
        <form id="LoginTotpForm" class="align-center" action="${url.loginAction}" method="post">
            <div class="mdc-textfield">
                <input id="totp" name="totp" autocomplete="off" type="text" class="mdc-textfield__input" autofocus />
                <label for="totp" class="mdc-textfield__label">${msg("loginTotpOneTime")}</label>
            </div>

            <div class="form-btn" style="float:none;">
                    <button class="mdc-button mdc-button--raised mdc-button--primary" name="login" id="kc-login" type="submit" value="Log In">${msg("doLogIn")}</button>
                    <button class="mdc-button mdc-button--raised" name="cancel" id="kc-cancel" type="submit" value="Cancel">${msg("doCancel")}</button>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>
