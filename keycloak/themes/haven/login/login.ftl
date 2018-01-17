<meta name="viewport" content="width=device-width, initial-scale=1.0">
<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=social.displayInfo; section>
    <#if section = "title">
        ${msg("loginTitle",(realm.displayName!''))}

    <#elseif section = "header">
        <h1 class="mdc-typography login-header">${msg("loginTitleHtml",(realm.displayNameHtml!''))}</h1>
    <#elseif section = "form">
    <div class="mdc-layout-grid__cell--span-4-tablet mdc-layout-grid__cell--span-6-phone mdc-layout-grid__cell--span-6-desktop login-box">
        <#if realm.password>
            <form id="kc-form-login" action="${url.loginAction}" method="post">
                <div>
                    <div class="mdc-form-field">
                        <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                            <#if usernameEditDisabled??>
                                <input id="username" class="mdc-textfield__input" name="username" value="${(login.username!'')}" type="text" disabled required />
                                <label for="username" class=" mdc-textfield__label"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                                <#else>
                                    <input id="username" class="mdc-textfield__input" name="username" value="${(login.username!'')}" type="text" autofocus autocomplete="off" required />
                                    <label for="username" class="mdc-textfield__label"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                            </#if>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="mdc-form-field">
                        <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                            <input id="password" class="mdc-textfield__input" name="password" type="password" autocomplete="off" required/>
                            <label for="password" class="mdc-textfield__label">${msg("password")}</label>
                        </div>
                    </div>
                    <div class="forgot-password">
                        <#if realm.resetPasswordAllowed>
                            <a href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
                        </#if>
                    </div>
                </div>

                <div class="${properties.kcFormGroupClass!}">
                    <button class="mdc-button mdc-button--primary mdc-button--raised btn-primary" name="login" id="kc-login" type="submit" value="${msg(" doLogIn")}">Log in</button>
                    <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                        <#if realm.rememberMe && !usernameEditDisabled??>
                            <div class="checkbox">
                                <label>
                                    <#if login.rememberMe??>
                                        <input id="rememberMe" name="rememberMe" type="checkbox" tabindex="3" checked> ${msg("rememberMe")}
                                    <#else>
                                        <input id="rememberMe" name="rememberMe" type="checkbox" tabindex="3"> ${msg("rememberMe")}
                                    </#if>
                                </label>
                            </div>
                        </#if>
                    </div>
                </div>
            </form>
        </#if>
    </div>
    <#elseif section = "info" >
    <div class="mdc-layout-grid__cell--span-6-desktop mdc-layout-grid__cell--span-4-tablet mdc-layout-grid__cell--span-6-phone registration-link">
        <#if realm.password && realm.registrationAllowed && !usernameEditDisabled??>
            <div id="Registration" style="align-self:center;">
                <span>${msg("noAccount")} <a href="${url.registrationUrl}">${msg("doRegister")}</a></span>
            </div>
        </#if>

        <#if realm.password && social.providers??>
            <div id="kc-social-providers">
                <ul>
                    <#list social.providers as p>
                        <li><a href="${p.loginUrl}" id="zocial-${p.alias}" class="zocial ${p.providerId}"> <span class="text">${p.displayName}</span></a></li>
                    </#list>
                </ul>
            </div>
        </#if>
    </div>
    </#if> <#-- end section = "title" -->
</@layout.registrationLayout>
