<title>${msg("loginTotpTitle")}</title>
<#import "template_2.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>

    <#if section = "header">
        <h2>${msg("loginTotpTitle")}</h2>
    <#elseif section = "form">
    <div class="m-auto col-lg-6">
      <ol id="kc-totp-settings">
          <li>
              <p>${msg("loginTotpStep1")}</p>
          </li>
          <li>
              <p>${msg("loginTotpStep2")}</p>
              <img id="kc-totp-secret-qr-code" src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="Figure: Barcode"><br/>
              <p class="py-2 code">${totp.totpSecretEncoded}</p>
          </li>
          <li>
              <p>${msg("loginTotpStep3")}</p>
          </li>
          <form action="${url.loginAction}" id="TotpForm" method="post">
              <div class="form-group">
                <label for="totp" class="mdc-textfield__label">${msg("authenticatorCode")}</label>
                  <input type="text" id="totp" name="totp" autocomplete="off" class="form-control" />
                  <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
              </div>
              <div class="float-right mt-3">
                  <button class="btn btn-secondary" type="submit" value="Sumbit">${msg("doSubmit")}</button>
                  <button class="btn btn-default" type="submit" value="Cancel">${msg("doCancel")}</button>
              </div>
          </form>
      </ol>
    </div>
    </#if>
</@layout.registrationLayout>
