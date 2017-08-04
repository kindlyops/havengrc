<#import "template.ftl" as layout>
    <@layout.mainLayout active='totp' bodyClass='totp' ; section>

        <#if totp.enabled>
            <div class="mdc-layout-grid heading">
                <div class="mdc-layout-grid__inner">
                    <h2 class="mdc-layout-grid__cell--span-8">${msg("authenticatorTitle")}</h2>
                </div>
            </div>

            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th colspan="2">${msg("configureAuthenticators")}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="provider">${msg("mobile")}</td>
                        <td class="action">
                            <a id="remove-mobile" href="${url.totpRemoveUrl}"><i class="pficon pficon-delete"></i></a>
                        </td>
                    </tr>
                </tbody>
            </table>

            <#else>
                <div class="mdc-layout-grid heading">
                    <div class="mdc-layout-grid__inner">
                        <h2 class="mdc-layout-grid__cell--span-8">${msg("authenticatorTitle")}</h2>
                    </div>
                </div>

                <hr />

                <ol>
                    <li>
                        <p>${msg("totpStep1")}</p>
                    </li>
                    <li>
                        <p>${msg("totpStep2")}</p>
                        <p><img src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="Figure: Barcode"></p>
                        <p><span class="code">${totp.totpSecretEncoded}</span></p>
                    </li>
                    <li>
                        <p>${msg("totpStep3")}</p>
                    </li>
                </ol>

                <div class="mdc-layout-grid">
                    <div class="mdc-layout-grid__inner" style="margin 0px 30px">
                        <form action="${url.totpUrl}" class="mdc-layout-grid__cell--span-12" id="TotpForm" method="post">
                            <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker?html}" />
                            <div class="mdc-textfield">
                                <input type="text" class="mdc-textfield__input" id="totp" name="totp" autocomplete="off" autofocus autocomplete="off" />
                                <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
                                <label for="totp" class="mdc-textfield__label">${msg("authenticatorCode")}</label>
                            </div>
                            <div class="form-btn">
                                <button type="submit" class="mdc-button mdc-button--raised mdc-button--primary" name="submitAction" value="Save">${msg("doSave")}</button>
                                <button type="submit" class="mdc-button mdc-button--raised" name="submitAction" value="Cancel">${msg("doCancel")}</button>
                            </div>
                        </form>
                    </div>
                </div>

        </#if>

    </@layout.mainLayout>
