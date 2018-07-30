<#import "template_2.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "title">
        ${msg("updatePasswordTitle")}
    <#elseif section = "header">
        <h2>${msg("updatePasswordTitle")}</h2>
    <#elseif section = "form">
    <div class="mx-auto d-lg-flex justify-content-lg-center">
        <form id="kc-passwd-update-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <input type="text" readonly value="this is not a login form" style="display: none;">
            <input type="password" readonly value="this is not a login form" style="display: none;">

            <div class="form-group">
                  <label for="password-new" class="">${msg("passwordNew")}</label>
                    <input type="password" id="password-new" name="password-new" class="form-control" autofocus autocomplete="off" />
            </div>

            <div class="form-group">
                  <label for="password-confirm" class="">${msg("passwordConfirm")}</label>
                    <input type="password" id="password-confirm" name="password-confirm" class="form-control" autocomplete="off" />
            </div>

            <div class="form-group">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="btn btn-block btn-primary" style="border-radius:25px;" type="submit" value="${msg("doSubmit")}"/>
                </div>
            </div>
        </form>
    </div>
    </#if>
</@layout.registrationLayout>
