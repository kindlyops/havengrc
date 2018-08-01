<#macro mainLayout active bodyClass>
<!doctype html>
<html>
  <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <meta name="robots" content="noindex, nofollow">

      <title>Account Management</title>
      <link rel="icon" href="${url.resourcesPath}/img/favicon-base.png" />
      <#if properties.styles?has_content>
          <#list properties.styles?split(' ') as style>
              <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
          </#list>
      </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script type="text/javascript" src="${url.resourcesPath}/${script}"></script>
        </#list>
    </#if>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  </head>
  <body class="admin-console user ${bodyClass}">
    <header class="navbar navbar-expand-lg fixed-top navbar-dark bg-primary">
      <button aria-controls="KCNavDrawer" aria-expanded="false" data-breakpoint="lg" data-target="#KCNavDrawer" data-toggle="navdrawer" data-type="permanent" class="navbar-toggler">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="navbar-brand mr-auto">Haven GRC</div>
      <ul class="navbar-nav">
        <#if realm.internationalizationEnabled>
          <li class="nav-item">
            <div class="kc-dropdown" id="kc-locale-dropdown">
                <a href="#" id="kc-current-locale-link" class="nav-link">${locale.current}</a>
                <ul>
                    <#list locale.supported as l>
                        <li class="kc-dropdown-item nav-item"><a class="nav-link" href="${l.url}">${l.label}</a></li>
                    </#list>
                </ul>
            </div>
          </li>
        </#if>
        <#if referrer?has_content && referrer.url?has_content>
          <li class="nav-item">
            <a href="${referrer.url}" id="referrer" class="nav-link">${msg("backTo",referrer.name)}</a>
          </li>
        </#if>
        <li class="nav-item">
          <a href="${url.logoutUrl}" class="nav-link">${msg("doSignOut")}</a>
        </li>
      </ul>
    </header>
    <div class="navdrawer navdrawer-permanent-lg navdrawer-permanent-clipped" id="KCNavDrawer" aria-hidden="true" tabindex="-1">
      <div class="navdrawer-content">
        <nav class="navdrawer-nav">
          <li class="nav-item">
            <a href="${url.accountUrl}" class="<#if active=='account'>active</#if> nav-link">
                <i class="material-icons mr-3" aria-hidden="true">account_circle</i>
                ${msg("account")}
            </a>
          </li>
          <#if features.passwordUpdateSupported>
          <li class="nav-item">
                <a href="${url.passwordUrl}" class="<#if active=='password'>active</#if> nav-link">
                    <i class="material-icons mr-3">fingerprint</i>
                    ${msg("password")}
                </a>
          </li>
          </#if>
          <li class="nav-item">
            <a href="${url.totpUrl}" class="<#if active=='totp'>active</#if> nav-link">
                <i class="material-icons mr-3">verified_user</i>
                ${msg("authenticator")}
            </a>
          </li>
          <#if features.identityFederation>
          <li class="nav-item">
            <a href="${url.socialUrl}" class="<#if active=='social'>active</#if> nav-link">
              <i class="material-icons mr-3">supervisor_account</i>
              ${msg("federatedIdentity")}
            </a>
          </li>
          </#if>
          <li class="nav-item">
            <a href="${url.sessionsUrl}" class="<#if active=='sessions'>active</#if> nav-link">
                <i class="material-icons mr-3">assignment</i>
                ${msg("sessions")}
            </a>
          </li>
          <#if features.log>
          <li class="nav-item">
            <a href="${url.logUrl}" class="<#if active=='log'>active</#if> nav-link">
                <i class="material-icons mr-3">assignment</i>
                ${msg("log")}
            </a>
          </li>
          </#if>
          <li class="nav-item">
            <a href="/" class="<#if active==''>active</#if> nav-link">
                <i class="material-icons mr-3">arrow_back</i>
                Return
            </a>
          </li>
        </nav>
        <div class="drawer-logo">
          <img src="${url.resourcesPath}/img/logo.png"  />
        </div>
      </div>
    </div>

    <main class="ml-lg-5 m-lg-5 pt-3">
      <div class="container">
        <div class="row">
          <div class="col-lg-11 mx-auto">
            <#if message?has_content>
                <div class="alert alert-${message.type} mt-3 mb-1">
                    <#if message.type=='success' ><i class="material-icons">check_circle</i></#if>
                    <#if message.type=='error' ><i class="material-icons">error</i></#if>
                    <span class="alert-text">${message.summary}</span>
                </div>
            </#if>
            <#nested "content">
          </div>
        </div>
      </div>
    </main>
  </body>
</html>
</#macro>
