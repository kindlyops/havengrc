<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
<#if section="title">
  ${msg("registerTitle")}
  <#elseif section="header">
      <h1 class="login-header">${msg("registerTitle")}</h1>
      <#elseif section="form">
          <div id="customer-info" class="m-auto">
              <form id="kc-register-form" class="" action="${url.registrationAction}" method="post">
                  <div class="form-group">
                      <input type="text" class="form-control" readonly value="this is not a login form" style="display: none;">
                      <input type="password" class="form-control" readonly value="this is not a login form" style="display: none;">
                  </div>                            <#if !realm.registrationEmailAsUsername>
                      <div class="form-group">
                          <label for="username" class="">${msg("username")}</label>
                              <input type="text" id="username" class="form-control ignore" name="username" value="${(register.formData.username!'')}" required autofocus />
                      </div>
                  </#if>
                  <div class="form-group">
                      <label for="firstName" class="">${msg("firstName")}</label>
                          <input type="text" id="firstName" class="form-control ignore" name="firstName" value="${(register.formData.firstName!'')}" required />
                  </div>
                  <div class="form-group">
                      <label for="lastName" class="">${msg("lastName")}</label>
                          <input type="text" id="lastName" class="form-control ignore" name="lastName" value="${(register.formData.lastName!'')}" required />
                  </div>
                  <div class="form-group">
                          <label for="email" class="">${msg("email")}</label>
                          <input type="text" id="email" class="form-control ignore" name="email" value="${(register.formData.email!'')}" required />
                  </div>
                  <#if passwordRequired>
                      <div class="form-group">
                          <label for="password" class="">${msg("password")}</label>
                              <input type="password" id="password" class="form-control ignore" name="password" required />
                      </div>
                      <div class="form-group">
                          <label for="password-confirm" class="">${msg("passwordConfirm")}</label>
                              <input type="password" id="password-confirm" class="form-control ignore" name="password-confirm" required />
                      </div>
                  </#if>
                  <#if recaptchaRequired??>
                      <div class="form-group">
                          <div class="${properties.kcInputWrapperClass!}">
                              <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                          </div>
                      </div>
                  </#if>
                  <div class="form-group ${properties.kcFormGroupClass!}">
                      <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                          <button class="btn btn-block btn-secondary" style="border-radius:25px;" type="submit" value="${msg(" Register")}">Register</button>
                      </div>
                  </div>
                      <div id="kc-form-options" class=" form-group ${properties.kcFormOptionsClass!}">
                          <div class="${properties.kcFormOptionsWrapperClass!}">
                              <p class="text-center"><a href="${url.loginUrl}">&laquo; ${msg("backToLogin")}</a></p>
                          </div>
                      </div>
                  </div>
                  <p class="text-danger" style="display:none;">There were errors while submitting</p>
          </form>
          </div>
</#if>
</@layout.registrationLayout>
