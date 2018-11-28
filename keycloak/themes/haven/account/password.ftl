<#import "template.ftl" as layout>
  <@layout.mainLayout active='password' bodyClass='password' ; section>

    <div class="heading py-3 mb-3">
      <h2>${msg("changePasswordHtmlTitle")}</h2>
      <span class="subtitle">
          <span class="required">*</span>
          ${msg("requiredFields")}
      </span>
    </div>

    <form action="${url.passwordUrl}" id="PasswordForm" method="post" class="px-4">
      <input type="text" readonly value="this is not a login form" style="display: none;">
      <input type="password" readonly value="this is not a login form" style="display: none;">

      <input type="text" id="username" name="username" value="${(account.username!'')}" autocomplete="username" readonly="readonly" style="display:none;">

      <#if password.passwordSet>
          <div class="form-group">
            <label for="password">${msg("password")}</label><span class="required">*</span>
            <input type="password" class="form-control" id="password" name="password" autocomplete="current-password" required>
          </div>
      </#if>

      <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker}">

      <div class="form-group">
        <label for="password-new">${msg("passwordNew")}</label><span class="required">*</span>
        <input type="password" class="form-control" id="password-new" name="password-new" autocomplete="new-password" autofocus required>
      </div>

      <div class="form-group">
        <label for="password-confirm">${msg("passwordConfirm")}</label><span class="required">*</span>
        <input type="password" class="form-control" id="password-confirm" name="password-confirm" autocomplete="new-password" required>
      </div>

      <div class="float-right mt-2">
        <button type="submit" class="btn btn-secondary" name="submitAction" value="Save">${msg("doSave")}</button>
        <button type="submit" class="btn btn-default" name="submitAction" value="Cancel">${msg("doCancel")}</button>
      </div>

    </form>
  </@layout.mainLayout>
