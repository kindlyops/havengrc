<meta name="viewport" content="width=device-width, initial-scale=1.0">
<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=social.displayInfo; section>
    <#if section = "title">
        ${msg("loginTitle",(realm.displayName!''))}

    <#elseif section = "header">
    <h1 class="login-header">${msg("loginTitleHtml",(realm.displayNameHtml!''))}</h1>
    <#elseif section="form">
    <div class="col-sm-6 d-sm-flex justify-content-sm-end pr-sm-5 login-box">
        <#if realm.password>
            <form id="kc-form-login" action="${url.loginAction}" method="post">
                    <div class="form-group">
                            <#if usernameEditDisabled??>
                                <label for="username" class=""><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                                <input id="username" class="form-control" name="username" value="${(login.username!'')}" type="text" disabled required />
                                <#else>
                                    <label for="username" class=""><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                                    <input id="username" class="form-control" name="username" value="${(login.username!'')}" type="text" autofocus autocomplete="off" required />
                            </#if>
                    </div>
                    <div class="form-group">
                        <label for="password" class="">${msg("password")}</label>
                            <input id="password" class="form-control" name="password" type="password" autocomplete="off" required />
                    </div>
                    <div class="form-group forgot-password">
                        <#if realm.resetPasswordAllowed>
                            <a href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
                        </#if>
                    </div>

                <div class="form-group">
                    <button class="btn btn-secondary btn-block" style="border-radius:25px;" name="login" id="kc-login" type="submit" value="${msg(" doLogIn")}">Log in</button>
                    <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                        <#if realm.rememberMe && !usernameEditDisabled??>
                            <div class="form-check">
                                <label class="form-check-label" for="rememberMe">
                                    <#if login.rememberMe??>
                                        <input id="rememberMe" name="rememberMe" class="form-check-input" type="checkbox" tabindex="3" checked> ${msg("rememberMe")}
                                        <#else>
                                            <input id="rememberMe" name="rememberMe" class="form-check-input" type="checkbox" tabindex="3"> ${msg("rememberMe")}
                                    </#if>
                                </label>
                            </div>
                        </#if>
                    </div>
                </div>
            </form>
        </#if>
        <div class="orText">OR</div>
    </div>
    <#elseif section="info">
        <div class="col-sm-6 d-sm-flex flex-column align-items-sm-start pl-sm-5 py-sm-4">
            <#if realm.password && social.providers??>
                <div id="kc-social-providers" class="mb-auto text-center">
                    <p class="mb-0 primary-font">Log In With:</p>
                        <#list social.providers as p>
                            <p class="mb-1"><a href="${p.loginUrl}" id="zocial-${p.alias}" class="zocial ${p.providerId}"> <span class="text">${p.displayName}</span></a></p>
                        </#list>
                </div>
            </#if>
            <#if realm.password && realm.registrationAllowed && !usernameEditDisabled??>
                <div id="Registration" class="text-center">
                    <p class="primary-font">${msg("noAccount")} <a href="${url.registrationUrl}">${msg("doRegister")}</a></p>
                </div>
            </#if>


        </div>
    </#if> <#-- end section = "title" -->
</@layout.registrationLayout>
