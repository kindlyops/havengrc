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

<body class="body-other-pages">
    <header class="navbar navbar-dark bg-primary">
        <div class="navbar-brand primary-font">
            Haven GRC
        </div>
        <ul class="navbar-nav">
          <#if realm.internationalizationEnabled>
          <li class="nav-item">
            <div id="kc-locale" class="${properties.kcLocaleClass!}">
                <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                    <div class="kc-dropdown" id="kc-locale-dropdown">
                        <a href="#" class="nav-link" id="kc-current-locale-link">${locale.current}</a>
                        <ul>
                            <#list locale.supported as l>
                                <li class="kc-dropdown-item nav-item"><a href="${l.url}" class="nav-link">${l.label}</a></li>
                            </#list>
                        </ul>
                    </div>
                </div>
            </div>
          </li>
          </#if>
        </ul>
    </header>

    <main class="my-5">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">

            <div class="heading pb-3 mb-4 text-center">
              <#nested "header">
            </div>

            <#if displayMessage && message?has_content>
                <div class="row justify-content-center">
                  <div class="col-lg-6">
                    <div class="alert alert-${message.type}">
                        <#if message.type = 'success'><i class="material-icons">check_circle</i></#if>
                        <#if message.type = 'warning'><i class="material-icons">warning</i></#if>
                        <#if message.type = 'error'><i class="material-icons">error</i></#if>
                        <#if message.type = 'info'><i class="material-icons">info</i></#if>
                        <span class="alert-text">${message.summary}</span>
                    </div>
                  </div>
                </div>
            </#if>

            <#nested "form">

            <#if displayInfo>
            <div class="row justify-content-center">
                <div id="kc-info-wrapper" class="col-lg-6">
                    <#nested "info">
                </div>
            </div>
            </#if>

          </div>
        </div>
      </div>
    </main>

</body>
</html>
</#macro>
