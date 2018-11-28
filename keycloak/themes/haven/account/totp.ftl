<#import "template.ftl" as layout>
<@layout.mainLayout active='totp' bodyClass='totp' ; section>

  <#if totp.enabled>
    <div class="heading py-3 mb-3">
        <h2>${msg("authenticatorTitle")}</h2>
        <span class="subtitle">
            <span class="required">*</span>
            ${msg("requiredFields")}
        </span>
    </div>

    <div class="px-4">
      <table class="table table-hover table-bordered table-sm" id="TotpTable">
        <thead>
          <tr>
            <th colspan="2">${msg("configureAuthenticators")}</th>
          </tr>
        </thead>
        <tbody>
          <tr>
              <td class="provider">${msg("mobile")}</td>
              <td class="action">
                  <form action="${url.totpUrl}" method="post" class="float-right">
                      <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker}">
                      <input type="hidden" id="submitAction" name="submitAction" value="Delete">
                      <button id="remove-mobile" class="invisible-btn"><i class="material-icons">delete</i></button>
                  </form>
              </td>
          </tr>
        </tbody>
      </table>
    </div>

  <#else>
    <div class="heading py-3 mb-3">
        <h2>${msg("authenticatorTitle")}</h2>
        <span class="subtitle">
            <span class="required">*</span>
            ${msg("requiredFields")}
        </span>
    </div>

    <div class="col-lg-6 px-4">
            <ol id="AccountForm">
                <li>
                    <p>${msg("totpStep1")}</p>
                </li>
                <li>
                    <p>${msg("totpStep2")}</p>
                    <img src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="Figure: Barcode" class="totp-img">
                    <div class=" py-2 code">${totp.totpSecretEncoded}</span>
                </li>
                <li>
                    <p>${msg("totpStep3")}</p>
                </li>
            </ol>

            <form action="${url.totpUrl}" id="TotpForm" method="post">
                <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker}" />
                <div class="form-group pl-3">
                    <label for="totp">${msg("authenticatorCode")}</label><span class="required">*</span>
                    <input type="text" class="form-control" id="totp" name="totp" autocomplete="off" required />
                    <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
                </div>

                <div class="float-right mt-2">
                    <button type="submit" class="btn btn-secondary" name="submitAction" value="Save">${msg("doSave")}</button>
                    <button type="submit" class="btn btn-default" name="submitAction" value="Cancel">${msg("doCancel")}</button>
                </div>
            </form>

        </div>
  </#if>

</@layout.mainLayout>
