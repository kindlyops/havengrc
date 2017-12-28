<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
        ${msg("registerWithTitle",(realm.displayName!''))}
    <#elseif section = "header">
        <h1 class="mdc-typography login-header">${msg("registerWithTitleHtml",(realm.displayNameHtml!''))}</h1>
    <#elseif section = "form">
    <div class="mdc-layout-grid__cell--span-12 align-center">
        <form id="kc-register-form" class="" action="${url.registrationAction}" method="post">
          <input type="text" readonly value="this is not a login form" style="display: none;">
          <input type="password" readonly value="this is not a login form" style="display: none;">

          <#if !realm.registrationEmailAsUsername>
          <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="username" class="mdc-textfield__input" name="username" value="${(register.formData.username!'')}" required autofocus />
                    <label for="username" class="mdc-textfield__label">${msg("username")}</label>
            </div>
           </div>
          </#if>
          <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="firstName" class="mdc-textfield__input" name="firstName" value="${(register.formData.firstName!'')}" required />
                    <label for="firstName" class="mdc-textfield__label">${msg("firstName")}</label>
            </div>
           </div>
           <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="lastName" class="mdc-textfield__input" name="lastName" value="${(register.formData.lastName!'')}" required />
                    <label for="lastName" class="mdc-textfield__label">${msg("lastName")}</label>
            </div>
           </div>
           <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="email" class="mdc-textfield__input" name="email" value="${(register.formData.email!'')}" required />
                    <label for="email" class="mdc-textfield__label">${msg("email")}</label>
            </div>
           </div>
            <#if passwordRequired>
           <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="password" id="password" class="mdc-textfield__input" name="password" required />
                    <label for="password" class="mdc-textfield__label">${msg("password")}</label>
            </div>
           </div>
           <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="password" id="password-confirm" class="mdc-textfield__input" name="password-confirm" required />
                    <label for="password-confirm" class="mdc-textfield__label">${msg("passwordConfirm")}</label>
            </div>
           </div>
            </#if>

            <#if recaptchaRequired??>
            <div class="form-group">
                <div class="${properties.kcInputWrapperClass!}">
                    <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                </div>
            </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="mdc-button mdc-button--primary mdc-button--raised btn-primary" type="submit" value="${msg("doRegister")}"/>
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
