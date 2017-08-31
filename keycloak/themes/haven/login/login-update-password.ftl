<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "title">
        ${msg("updatePasswordTitle")}
    <#elseif section = "header">
        <h2>${msg("updatePasswordTitle")}</h2>
    <#elseif section = "form">
    <div class="mdc-layout-grid__cell--span-12 align-center">
        <form id="kc-passwd-update-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <input type="text" readonly value="this is not a login form" style="display: none;">
            <input type="password" readonly value="this is not a login form" style="display: none;">

            <div class="${properties.kcFormGroupClass!}">
                <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="password" id="password-new" name="password-new" class="mdc-textfield__input" autofocus autocomplete="off" />
                    <label for="password-new" class="mdc-textfield__label">${msg("passwordNew")}</label>
                </div>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="password" id="password-confirm" name="password-confirm" class="mdc-textfield__input" autocomplete="off" />
                    <label for="password-confirm" class="mdc-textfield__label">${msg("passwordConfirm")}</label>
                </div>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="mdc-button mdc-button--primary mdc-button--raised btn-primary" type="submit" value="${msg("doSubmit")}"/>
                </div>
            </div>
        </form>
    </div>
    </#if>
</@layout.registrationLayout>
