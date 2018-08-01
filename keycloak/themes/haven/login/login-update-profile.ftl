<#import "template_2.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        <h2>${msg("loginProfileTitle")}</h2>
    <#elseif section = "form">
        <form id="kc-update-profile-form" class="col-sm-8 m-auto px-4" action="${url.loginAction}" method="post">
            <#if user.editUsernameAllowed>
                <div class="form-group ${messagesPerField.printIfExists('username',properties.kcFormGroupErrorClass!)}">
                        <label for="username" class="$">${msg("username")}</label>
                        <input type="text" id="username" name="username" value="${(user.username!'')}" class="form-control"/>
                </div>
            </#if>
            <div class="form-group ${messagesPerField.printIfExists('email',properties.kcFormGroupErrorClass!)}">
                    <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label>
                    <input type="text" id="email" name="email" value="${(user.email!'')}" class="form-control" />
            </div>

            <div class="form-group ${messagesPerField.printIfExists('firstName',properties.kcFormGroupErrorClass!)}">
                    <label for="firstName" class="${properties.kcLabelClass!}">${msg("firstName")}</label>
                    <input type="text" id="firstName" name="firstName" value="${(user.firstName!'')}" class="form-control" />
            </div>

            <div class="form-group ${messagesPerField.printIfExists('lastName',properties.kcFormGroupErrorClass!)}">
                    <label for="lastName" class="${properties.kcLabelClass!}">${msg("lastName")}</label>
                    <input type="text" id="lastName" name="lastName" value="${(user.lastName!'')}" class="form-control" />
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                    </div>
                </div>

                <div id="kc-form-buttons" class=" float-right ${properties.kcFormButtonsClass!}">
                    <input role="button" class="btn btn-secondary" type="submit" value="${msg("doSubmit")}" />
                </div>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>
