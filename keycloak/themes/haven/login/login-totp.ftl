<#import "template_2.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
        ${msg("loginTitle",realm.displayName)}
    <#elseif section = "header">
        <h2>${msg("loginTitleHtml",realm.displayNameHtml)}</h2>
    <#elseif section = "form">
        <form id="LoginTotpForm" action="${url.loginAction}" method="post">
          <div class="form-row justify-content-center">
            <div class="form-group col-lg-3">
              <label for="totp" class="text-left">${msg("loginTotpOneTime")}</label>
                <input id="totp" name="totp" autocomplete="off" type="text" class="form-control" autofocus />
            </div>
          </div>

          <div class="mt-3 text-center">
            <button class="btn btn-secondary" name="login" id="kc-login" type="submit" value="Log In">${msg("doLogIn")}</button>
            <button class="btn btn-default" name="cancel" id="kc-cancel" type="submit" value="Cancel">${msg("doCancel")}</button>
          </div>
        </form>
    </#if>
</@layout.registrationLayout>
