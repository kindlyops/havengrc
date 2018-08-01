<#import "template_2.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "title">
        ${msg("emailForgotTitle")}
    <#elseif section = "header">
        <h2>${msg("emailForgotTitle")}</h2>
    <#elseif section = "form">
    <p class="text-center">
        ${msg("emailInstruction")}
    </p>
    <div class="col-lg-6 mx-auto pt-3 d-lg-flex justify-content-lg-center">
        <form id="kc-reset-password-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <div class="form-group">
                <label for="username" class="">
                    <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                </label>
                    <input type="text" id="username" name="username" class="form-control" autofocus/>
            </div>
            <div class="form-group">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="btn btn-primary btn-block" style="border-radius:25px;" type="submit" value="${msg("doSubmit")}"/>
                </div>
            </div>
            <div class="form-group">
                <div id="kc-form-options" class="text-center">
                        <p><a href="${url.loginUrl}">&laquo; ${msg("backToLogin")}</a></p>
                </div>
                </div>
            </div>
        </form>
    </div>
    </#if>
</@layout.registrationLayout>
