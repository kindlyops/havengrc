<link href="https://fonts.googleapis.com/css?family=Roboto:400,700,900" rel="stylesheet">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=social.displayInfo; section>
    <#if section = "title">
        ${msg("loginTitle",(realm.displayName!''))}

    <#elseif section = "header">
        <img src="${url.resourcesPath}/img/logo@2x.png" width="82" height="71" />
        <h1 class="mdc-typography header">${msg("loginTitleHtml",(realm.displayNameHtml!''))}</h1>
    <#elseif section = "form">
        <#if realm.password>
            <form id="kc-form-login" action="${url.loginAction}" method="post">
                <div>
                    <div class="mdc-form-field">
                        <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                            <#if usernameEditDisabled??>
                                <input id="username" class="mdc-textfield__input" name="username" value="${(login.username!'')?html}" type="text" disabled required />
                                <label for="username" class=" mdc-textfield__label"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                                <#else>
                                    <input id="username" class="mdc-textfield__input" name="username" value="${(login.username!'')?html}" type="text" autofocus autocomplete="off" required />
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
                </div>

                <div class="${properties.kcFormGroupClass!}">
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
                        <div class="${properties.kcFormOptionsWrapperClass!}">
                            <#if realm.resetPasswordAllowed>
                                <span><a href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a></span>
                            </#if>
                        </div>
                    </div>
                    <button class="mdc-button mdc-button--primary mdc-button--raised login-btn" name="login" id="kc-login" type="submit" value="${msg(" doLogIn")}">Log in</button>
                </div>
            </form>
        </#if>
    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !usernameEditDisabled??>
            <div id="kc-registration">
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

    </#if> <#-- end section = "title" -->
</@layout.registrationLayout>

<div class="bottom-container align-center">
    <div>
        <img alt="Wireframe graphic of compliance and risk dashboard Haven GRC" data-rjs="2" id="footer-lines" src="/img/footer_lines@2x.png" data-rjs-processed="true" title="" >
    </div>
    <footer class="mdc-toolbar align-center">
        <div class="mdc-toolbar__row">
            <section class="mdc-toolbar__section" style="align-items:center !important;">
                <span>© 2017 <a href="https://kindlyops.com" title="Kindly Ops Website">KINDLY OPS</a></span>
            </section>
        </div>
    </footer>
</div>

<script>window.mdc.autoInit();</script>
<script>
    mdc.textfield.MDCTextfield.attachTo(document.querySelector('.mdc-textfield'));
</script>
<script>
    mdc.ripple.MDCRipple.attachTo(document.querySelector('.mdc-button'));
</script>
