<#import "template.ftl" as layout>
    <@layout.mainLayout active='password' bodyClass='password' ; section>

        <div class="mdc-layout-grid heading">
            <div class="mdc-layout-grid__inner">

                <h2 class="mdc-typography mdc-layout-grid__cell--span-8">${msg("changePasswordHtmlTitle")}</h2>
                <span class="subtitle mdc-layout-grid__cell mdc-layout-grid--align-right">${msg("allFieldsRequired")}</span>
            </div>
        </div>

        <div class="mdc-layout-grid">
            <div class="mdc-layout-grid__inner" style="margin: 0px 30px;">
                <form action="${url.passwordUrl}" class="mdc-layout-grid__cell--span-12" id="PasswordForm" method="post">
                    <input type="text" readonly value="this is not a login form" style="display: none;">
                    <input type="password" readonly value="this is not a login form" style="display: none;">

                    <#if password.passwordSet>
                        <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                            <input type="password" class="mdc-textfield__input" id="password" name="password" autofocus autocomplete="off" required />
                            <label for="password" class="mdc-textfield__label">${msg("password")}</label>
                        </div>
                    </#if>

                    <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker?html}">

                    <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                        <input type="password" class="mdc-textfield__input" id="password-new" name="password-new" autocomplete="off" required />
                        <label for="password-new" class="mdc-textfield__label">${msg("passwordNew")}</label>
                    </div>

                    <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                        <input type="password" class="mdc-textfield__input" id="password-confirm" name="password-confirm" autocomplete="off" required />
                        <label for="password-confirm" class="mdc-textfield__label two-lines">${msg("passwordConfirm")}</label>
                    </div>

                    <div class="form-btn">
                        <button type="submit" class="mdc-button mdc-button--raised mdc-button--primary" name="submitAction" value="Save">${msg("doSave")}</button>
                        <button type="submit" class="mdc-button mdc-button--raised" name="submitAction" value="Cancel">${msg("doCancel")}</button>
                    </div>
                </form>
            </div>
        </div>
    </@layout.mainLayout>
