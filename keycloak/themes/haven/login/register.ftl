<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
        ${msg("registerWithTitle",(realm.displayName!''))}
    <#elseif section = "header">
        <h1 class="mdc-typography login-header">${msg("registerWithTitleHtml",(realm.displayNameHtml!''))}</h1>
    <#elseif section = "form">
    <div class="mdc-layout-grid__cell--span-12 align-center">
        <form id="kc-register-form" class="" action="${url.registrationAction}" method="post">
          <input type="text" readonly value="this is not a login form" style="display: none;">
          <input type="password" readonly value="this is not a login form" style="display: none;">

          <#if !realm.registrationEmailAsUsername>
          <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="username" class="mdc-textfield__input" name="username" value="${(register.formData.username!'')}" required autofocus />
                    <label for="username" class="mdc-textfield__label">${msg("username")}</label>
            </div>
           </div>
          </#if>
          <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="firstName" class="mdc-textfield__input" name="firstName" value="${(register.formData.firstName!'')}" required />
                    <label for="firstName" class="mdc-textfield__label">${msg("firstName")}</label>
            </div>
           </div>
           <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="lastName" class="mdc-textfield__input" name="lastName" value="${(register.formData.lastName!'')}" required />
                    <label for="lastName" class="mdc-textfield__label">${msg("lastName")}</label>
            </div>
           </div>
           <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="user.attributes.organization" class="mdc-textfield__input" name="user.attributes.organization" value="${(register.formData.organization!'')}" required />
                    <label for="user.attributes.organization" class="mdc-textfield__label">${msg("organization")}</label>
            </div>
           </div>
           <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="text" id="email" class="mdc-textfield__input" name="email" value="${(register.formData.email!'')}" required />
                    <label for="email" class="mdc-textfield__label">${msg("email")}</label>
            </div>
           </div>
            <#if passwordRequired>
           <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="password" id="password" class="mdc-textfield__input" name="password" required />
                    <label for="password" class="mdc-textfield__label">${msg("password")}</label>
            </div>
           </div>
           <div>
            <div class="mdc-textfield" data-mdc-auto-init="MDCTextfield">
                    <input type="password" id="password-confirm" class="mdc-textfield__input" name="password-confirm" required />
                    <label for="password-confirm" class="mdc-textfield__label">${msg("passwordConfirm")}</label>
            </div>
           </div>
            </#if>

            <#if recaptchaRequired??>
            <div class="form-group">
                <div class="${properties.kcInputWrapperClass!}">
                    <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                </div>
            </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="mdc-button mdc-button--primary mdc-button--raised btn-primary" type="submit" value="${msg("doRegister")}"/>
                </div>
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                        <span><a href="${url.loginUrl}">${msg("backToLogin")}</a></span>
                    </div>
                </div>
            </div>
            <div class="navbar navbar-static-top">
            <div class="container">
                <div class="navbar-header">
                    <div class="h1"></div>
                </div>
            </div>
        </div>
        <div id="container" class="checkout container">
            <div id="customer-info" class="row">
                <div class="col-sm-7" id="checkout_info">
                    <form action="/checkout_iframe/checkout" method="post"  id="subscribe-form">
                        <div class="page-header">
                            <h3>Tell us about yourself</h3>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">

                                <div class="form-group">
                                    <label for="customer[first_name]">First Name</label>
                                    <input type="text" class="form-control" name="customer[first_name]"
                                           maxlength="50" required data-msg-required="cannot be blank">
                                    <small for="customer[first_name]" class="text-danger"></small>
                                </div>

                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="customer[last_name]">Last Name</label>
                                    <input type="text" class="form-control" name="customer[last_name]" maxlength="50"
                                           required data-msg-required="cannot be blank">
                                    <small for="customer[last_name]" class="text-danger"></small>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="customer[email]">Email</label>
                                    <input id="email" type="text" class="form-control" name="customer[email]" maxlength="50"
                                               data-rule-required="true" data-rule-email="true"
                                               data-msg-required="Please enter your email address"
                                               data-msg-email="Please enter a valid email address">
                                    <small for="customer[email]" class="text-danger"></small>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="customer[company]">Company</label>
                                    <input type="text" class="form-control" name="customer[company]" maxlength="50"
                                           required data-msg-required="cannot be blank">
                                    <small for="customer[company]" class="text-danger"></small>
                                </div>
                            </div>
                        </div>
                        <p class="text-danger" style="display:none;">There were errors while submitting</p>
                        <div class="form-inline">
                            <div class="form-group">
                            <input type="submit" class="submit-btn btn btn-success btn-lg" value="Proceed to Payment">
                            </div>
                            <div class="form-group">
                                <a class="btn btn-link" href="index.html">Cancel</a>
                            </div>
                            <div class="form-group">
                            <span class="subscribe-process process" style="display:none;">Processing&hellip;</span>
                            </div>
                            <div class="form-group">
                                <span class="alert-danger text-danger"></span>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div id="checkout-info" class="row">

            </div>
        </div>
        <br><br>


        <div class="modal fade" id="paymentModal" tabindex="-1" role="dialog" aria-labelledby="paymentModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content" style="max-width: 540px;">
                    <div class="modal-header">
                        <h4 class="modal-title text-center">
                            Payment Information
                        </h4>
                    </div>
                    <!--add custom attribute data-cb-modal-body="body" to modal body -->
                    <div class="modal-body"  data-cb-modal-body="body" style="padding-left: 0px;padding-right: 0px;">
                    </div>
                </div>
            </div>
        </div>
        </form>
    </div>
    </#if>
</@layout.registrationLayout>
