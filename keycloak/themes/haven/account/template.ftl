<#macro mainLayout active bodyClass>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700,900" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,700" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body class="admin-console user ${bodyClass} mdc-typography">
    <aside class="mdc-persistent-drawer mdc-typography sm-screen-drawer lg-screen-drawer" id="aside">
        <nav class="mdc-persistent-drawer__drawer bs-sidebar">
            <div class="nav-flex">
                <div class="mdc-persistent-drawer__toolbar-spacer"></div>
                <nav id="icon-with-text-demo" class="mdc-persistent-drawer__content mdc-list">
                    <a href="${url.accountUrl}" class="<#if active=='account'>mdc-persistent-drawer--selected</#if> mdc-list-item">
                        <i class="material-icons mdc-list-item__start-detail" aria-hidden="true">account_circle</i>
                        ${msg("account")}
                    </a>
                    <#if features.passwordUpdateSupported>
                        <a href="${url.passwordUrl}" class="<#if active=='password'>mdc-persistent-drawer--selected</#if> mdc-list-item">
                            <i class="material-icons mdc-list-item__start-detail">fingerprint</i>
                            ${msg("password")}
                        </a>
                    </#if>
                        <a href="${url.totpUrl}" class="<#if active=='totp'>mdc-persistent-drawer--selected</#if> mdc-list-item">
                            <i class="material-icons mdc-list-item__start-detail">verified_user</i>
                            ${msg("authenticator")}
                        </a>
                    <#if features.identityFederation>
                            <a href="${url.socialUrl}" class="<#if active=='social'>mdc-persistent-drawer--selected</#if> mdc-list-item">
                                <i class="material-icons mdc-list-item__start-detail">arrow_back</i>
                                ${msg("federatedIdentity")}
                            </a>
                    </#if>
                        <a href="${url.sessionsUrl}" class="<#if active=='sessions'>mdc-persistent-drawer--selected</#if> mdc-list-item">
                            <i class="material-icons mdc-list-item__start-detail">assignment</i>
                            ${msg("sessions")}
                        </a>
                        <a href="${url.applicationsUrl}" class="<#if active=='applications'>mdc-persistent-drawer--selected</#if> mdc-list-item">
                            <i class="material-icons mdc-list-item__start-detail">view_list</i>
                            ${msg("applications")}
                        </a>
                    <#if features.log>
                            <a href="${url.logUrl}" class="<#if active=='log'>mdc-persistent-drawer--selected</#if> mdc-list-item">
                                <i class="material-icons mdc-list-item__start-detail">arrow_back</i>
                                ${msg("log")}
                            </a>
                    </#if>
                    <a href="http://localhost:2015/" class="<#if active==''>mdc-persistent-drawer--selected</#if> mdc-list-item">
                        <i class="material-icons mdc-list-item__start-detail">arrow_back</i>
                        Return
                    </a>
                </nav>
            </div>
            <div class="drawer-logo">
                <img src="${url.resourcesPath}/img/logo.png"  />
            </div>
        </nav>
    </aside>
    <div class="content mdc-toolbar-fixed-adjust">
        <header class="mdc-toolbar mdc-toolbar--fixed header">
            <div class="mdc-toolbar__row">
                <section class="mdc-toolbar__section mdc-toolbar__section--align-start">
                    <button class="menu material-icons mdc-toolbar__icon--menu">menu</button>
                    <h1 class="mdc-toolbar__title">Haven GRC</h1>
                </section>
                <section class="mdc-toolbar__section mdc-toolbar__section--align-end">
                    <#if realm.internationalizationEnabled>
                            <div class="kc-dropdown" id="kc-locale-dropdown">
                                <a href="#" id="kc-current-locale-link">${locale.current}</a>
                                <ul>
                                    <#list locale.supported as l>
                                        <li class="kc-dropdown-item"><a href="${l.url}">${l.label}</a></li>
                                    </#list>
                                </ul>
                            </div>
                    </#if>
                    <#if referrer?has_content && referrer.url?has_content>
                        <a href="${referrer.url}" id="referrer" class="mdc-toolbar__title">${msg("backTo",referrer.name)}</a>
                    </#if>
                    <a href="${url.logoutUrl}" class="mdc-toolbar__title" style="margin-right:24px;">${msg("doSignOut")}</a>
                </section>
            </div>
        </header>
        <main class="main">
            <#if message?has_content>
                <div class="alert alert-${message.type}">
                    <#if message.type=='success' ><i class="material-icons">check_circle</i></#if>
                    <#if message.type=='error' ><i class="material-icons">error</i></#if>
                    <span class="alert-text">${message.summary}</span>
                </div>
            </#if>
            <#nested "content">
        </main>
    </div>
    <script>mdc.drawer.MDCPersistentDrawer.attachTo(document.querySelector('.mdc-persistent-drawer'));</script>
    <script>window.mdc.autoInit();</script>
    <script>
        mdc.textfield.MDCTextfield.attachTo(document.querySelector('.mdc-textfield'));
    </script>
    <script>
        mdc.ripple.MDCRipple.attachTo(document.querySelector('.mdc-button'));
    </script>
    <script>
        let drawer = new mdc.drawer.MDCPersistentDrawer(document.querySelector('.mdc-persistent-drawer'));
        document.querySelector('.menu').addEventListener('click', function() {
          drawer.open = !drawer.open;
        });
    </script>

</body>
</html>
</#macro>
