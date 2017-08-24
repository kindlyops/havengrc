<title>${msg("loginTotpTitle")}</title>
<#import "template_2.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>

    <#if section = "header">
        <h2>${msg("loginTotpTitle")}</h2>
    <#elseif section = "form">
    <ol id="kc-totp-settings">
        <li>
            <p>${msg("loginTotpStep1")}</p>
        </li>
        <li>
            <p>${msg("loginTotpStep2")}</p>
            <img id="kc-totp-secret-qr-code" src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="Figure: Barcode"><br/>
            <span class="code">${totp.totpSecretEncoded}</span>
        </li>
        <li>
            <p>${msg("loginTotpStep3")}</p>
        </li>
    </ol>
    <form action="${url.loginAction}" class="mdc-layout-grid__cell--span-12" id="TotpForm" method="post">
        <div class="mdc-textfield">
            <input type="text" id="totp" name="totp" autocomplete="off" class="mdc-textfield__input" />
            <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
            <label for="totp" class="mdc-textfield__label">${msg("authenticatorCode")}</label>
        </div>
        <div class="form-btn">
            <button class="mdc-button mdc-button--raised mdc-button--primary" type="submit" value="Sumbit">${msg("doSubmit")}</button>
            <button class="mdc-button mdc-button--raised" type="submit" value="Cancel">${msg("doCancel")}</button>
        </div>
    </form>
    </#if>
</@layout.registrationLayout>
