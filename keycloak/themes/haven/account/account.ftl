<#import "template.ftl" as layout>
<@layout.mainLayout active='account' bodyClass='user'; section>

    <div class="mdc-layout-grid heading">
        <div class="mdc-layout-grid__inner">
            <h2 class="mdc-layout-grid__cell--span-8-desktop mdc-layout-grid__cell--span-4-phone mdc-layout-grid__cell--span-4-tablet">${msg("editAccountHtmlTitle")}</h2>
            <span class="subtitle mdc-layout-grid__cell mdc-layout-grid--align-right">
                <span class="required">*</span>
                ${msg("requiredFields")}
            </span>
        </div>
    </div>

    <div class="mdc-layout-grid">
        <div class="mdc-layout-grid__inner container-margin">
            <form action="${url.accountUrl}" class="mdc-layout-grid__cell--span-12" id="AccountForm" method="post">
                <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker}">

                <#if !realm.registrationEmailAsUsername>
                    <div class="${messagesPerField.printIfExists('username','has-error')}">
                        <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                            <input type="text" class="mdc-textfield__input" id="username" name="username" <#if !realm.editUsernameAllowed>disabled="disabled"</#if> value="${(account.username!'')}"/>
                            <label for="username" class="mdc-textfield__label">${msg("username")}</label> <#if realm.editUsernameAllowed><span class="required">*</span></#if>
                        </div>
                    </div>
                </#if>

                <div class="${messagesPerField.printIfExists('email','has-error')}">
                    <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                        <input type="text" class="mdc-textfield__input" id="email" name="email" required autofocus value="${(account.email!'')}"/>
                        <label for="email" class="mdc-textfield__label">${msg("email")}</label>
                    </div>
                </div>

                <div class="${messagesPerField.printIfExists('organization','has-error')}">
                    <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                        <input type="text" class="mdc-textfield__input" id="user.attributes.organization" name="user.attributes.organization" value="${(account.attributes.organization!'')}" required/>
                        <label for="user.attributes.organization" class="mdc-textfield__label">${msg("organization")}</label>
                    </div>
                </div>

                <div class="${messagesPerField.printIfExists('firstName','has-error')}">
                    <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                        <input type="text" class="mdc-textfield__input" id="firstName" name="firstName" value="${(account.firstName!'')}" required/>
                        <label for="firstName" class="mdc-textfield__label">${msg("firstName")}</label>
                    </div>
                </div>

                <div class="${messagesPerField.printIfExists('lastName','has-error')}">
                    <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                        <input type="text" class="mdc-textfield__input" id="lastName" name="lastName" value="${(account.lastName!'')}" required/>
                        <label for="lastName" class="mdc-textfield__label">${msg("lastName")}</label>
                    </div>
                </div>


                <div class="form-btn">
                    <#if url.referrerURI??><a href="${url.referrerURI}">${msg("backToApplication")}/a></#if>
                    <button type="submit" class="mdc-button mdc-button--raised mdc-button--accent" name="submitAction" value="Save">${msg("doSave")}</button>
                    <button type="submit" class="mdc-button mdc-button--raised" name="submitAction" value="Cancel">${msg("doCancel")}</button>
                </div>

            </form>
        </div>
    </div>
</@layout.mainLayout>
