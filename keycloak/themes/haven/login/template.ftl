<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="${properties.kcHtmlClass!}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title><#nested "title"></title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700,900" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body class="${properties.kcBodyClass!}">

    <div id="kc-logo"><a href="${properties.kcLogoLink!'#'}"><div id="kc-logo-wrapper"></div></a></div>


    <div class="mdc-layout-grid">
        <div id="kc-header-wrapper" class="mdc-layout-grid__inner header-container align-center">
            <div class="mdc-layout-grid__cell--span-12">
                <#nested "header">
            </div>
        </div>
    </div>

    <#if realm.internationalizationEnabled>
        <div id="kc-locale" class="${properties.kcLocaleClass!}">
            <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                <div class="kc-dropdown" id="kc-locale-dropdown">
                    <a href="#" id="kc-current-locale-link">${locale.current}</a>
                    <ul>
                        <#list locale.supported as l>
                            <li class="kc-dropdown-item"><a href="${l.url}">${l.label}</a></li>
                        </#list>
                    </ul>
                </div>
            </div>
        </div>
    </#if>

    <div class="login-content-container align-center mdc-layout-grid">
        <div class="mdc-layout-grid__inner">
            <#if displayMessage && message?has_content>
                <div class="mdc-layout-grid__cell--span-12">
                    <div class="alert alert-${message.type}">
                        <#if message.type = 'success'><i class="material-icons">check_circle</i></#if>
                        <#if message.type = 'warning'><i class="material-icons">warning</i></#if>
                        <#if message.type = 'error'><i class="material-icons">error</i></#if>
                        <#if message.type = 'info'><i class="material-icons">info</i></#if>
                        <span class="alert-text">${message.summary}</span>
                    </div>
                </div>
            </#if>

            <div id="kc-form" class="mdc-layout-grid__cell--span-12">
                <#nested "form">
            </div>

            <#if displayInfo>
                <div id="kc-info" class="${properties.kcInfoAreaClass!}">
                    <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                        <#nested "info">
                    </div>
                </div>
            </#if>
        </div>
    </div>


    <script>window.mdc.autoInit();</script>
    <script>
        mdc.textfield.MDCTextfield.attachTo(document.querySelector('.mdc-textfield'));
    </script>
    <script>
        mdc.ripple.MDCRipple.attachTo(document.querySelector('.mdc-button'));
    </script>

</body>
</html>
</#macro>
