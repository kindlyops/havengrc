<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "title">
        ${msg("emailForgotTitle")}
    <#elseif section = "header">
        <h2>${msg("emailForgotTitle")}</h2>
    <#elseif section = "form">
    <div class="mdc-layout-grid__cell--span-12 align-center">
        ${msg("emailInstruction")}
    </div>
    <div class="mdc-layout-grid__cell--span-12 align-center">
        <form id="kc-reset-password-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <div class="${properties.kcFormGroupClass!}">
                <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="username" name="username" class="mdc-textfield__input" autofocus/>
                    <label for="username" class="mdc-textfield__label">
                        <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                    </label>
                </div>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="mdc-button mdc-button--primary mdc-button--raised btn-primary" type="submit" value="${msg("doSubmit")}"/>
                </div>
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                        <span><a href="${url.loginUrl}">${msg("backToLogin")}</a></span>
                    </div>
                </div>
            </div>
        </form>
    </div>
    </#if>
</@layout.registrationLayout>
