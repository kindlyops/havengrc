<#import "template.ftl" as layout>
<@layout.mainLayout active='account' bodyClass='user'; section>

  <div class="heading py-3 mb-3">
    <h2>${msg("editAccountHtmlTitle")}</h2>
    <span class="subtitle">
        <span class="required">*</span>
        ${msg("requiredFields")}
    </span>
  </div>

  <form action="${url.accountUrl}" class="px-4" id="AccountForm" method="post">
    <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker}"/>

    <#if !realm.registrationEmailAsUsername>
    <div class="form-group">
      <div class="${messagesPerField.printIfExists('username','has-error')}">
        <label for="username" class="">${msg("username")}*</label> <#if realm.editUsernameAllowed><span class="required">*</span></#if>
        <input type="text" class="form-control" id="username" name="username" <#if !realm.editUsernameAllowed>disabled="disabled"</#if> value="${(account.username!'')}"/>
      </div>
    </div>
    </#if>

    <div class="form-group">
      <div class="${messagesPerField.printIfExists('email','has-error')}">
        <label for="email" class="">${msg("email")}</label><span class="required">*</span>
        <input type="text" class="form-control" id="email" name="email" required autofocus value="${(account.email!'')}"/>
      </div>
    </div>

    <div class="form-group">
      <div class="${messagesPerField.printIfExists('firstName','has-error')}">
        <label for="firstName" class="">${msg("firstName")}</label><span class="required">*</span>
        <input type="text" class="form-control" id="firstName" name="firstName" value="${(account.firstName!'')}" required/>
      </div>
    </div>

    <div class="form-group">
      <div class="${messagesPerField.printIfExists('lastName','has-error')}">
        <label for="lastName" class="">${msg("lastName")}</label><span class="required">*</span>
        <input type="text" class="form-control" id="lastName" name="lastName" value="${(account.lastName!'')}" required/>
      </div>
    </div>

    <div class="float-right mt-2">
      <#if url.referrerURI??><a href="${url.referrerURI}" role="button" class="btn btn-default">${msg("backToApplication")}/a></#if>
      <button class="btn btn-secondary" role="button" type="submit" name="submitAction" value="Save">${msg("doSave")}</button>
      <button class="btn btn-default" role="button" type="submit" name="submitAction">${msg("doCancel")}</button>
    </div>
  </form>
</@layout.mainLayout>
