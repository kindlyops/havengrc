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
    <script src="https://use.typekit.net/fru8myg.js"></script>
    <script>try{Typekit.load({ async: true });}catch(e){}</script>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.chargebee_styles?has_content>
        <#list properties.chargebee_styles?split(' ') as chargebee_style>
            <link href="${url.resourcesPath}/${chargebee_style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if properties.chargebee_scripts?has_content>
        <#list properties.chargebee_scripts?split(' ') as chargebee_script>
            <script src="${chargebee_script}" type="text/javascript"></script>
        </#list>
    </#if>
    <script type="text/javascript">

            function showEmbeddedCheckout() {
                <#if siteName?has_content>
                var hostedPageURL = "${pageUrl}";
                var hostedPageId = "${pageId}";
                var siteName = "${siteName}";
                <#else>
                var hostedPageURL = "NONE";
                var hostedPageId = "NONE";
                var siteName = "NONE";
                </#if>
                var iframeContainer = $('#checkout-info');
                ChargeBee.embed(hostedPageURL, siteName).load({
                    /*
                    * This function will be called when iframe is created.
                    * addIframe callback will recieve iframe as parameter.
                    * you can use this iframe to add iframe to your page.
                    * Loading image in container can also be showed in this callback.
                    * Note: visiblity will be none for the iframe at this moment
                    */
                    addIframe: function(iframe) {
                        iframeContainer.append(iframe);
                    },

                    /*
                    * This function will be called once when iframe is loaded.
                    * Since checkout pages are responsive you need to handle only height.
                    */        
                    onLoad: function(iframe, width, height) {
                        var style= 'border:none;overflow:hidden;width:100%;';
                        style = style + 'height:' + height + 'px;';
                        style = style + 'display:none;';//This is for slide down effect
                        iframe.setAttribute('style', style);
                        $(iframe).slideDown(1000);
                    },

                    /*
                    * This will be triggered when any content of iframe is resized.
                    */        
                    onResize: function(iframe, width, height) {
                        var style = 'border:none;overflow:hidden;width:100%;';
                        style = style + 'height:' + height + 'px;';
                        iframe.setAttribute('style',style);
                    },

                    /*
                    * This will be triggered when checkout is complete.
                    */        
                    onSuccess: function(iframe) {
                        // TODO: when chargebee told us it successfully created a subscription,
                        //  we need to trigger the POST of the keycloak registration form
                        // We include hostedPageId in the form data. This will allow keycloak to register
                        // the user and retrieve the subscription info for that user from the hostedPageId
                        //redirectCall(hostedPageId);
                        alert("onSuccess");
                    },

                    /*
                    * This will be triggered when user clicks on cancel button. 
                    */
                    onCancel: function(iframe) {
                        alert("Payment Aborted !!");
                    }
                });
            }

            $(document).ready(function() {
                // show chargebee subscription form 
                showEmbeddedCheckout();
            });
        </script>
</head>

<body class="${properties.kcBodyClass!}">

    <div id="kc-logo"><a href="${properties.kcLogoLink!'#'}"><div id="kc-logo-wrapper"></div></a></div>


    <div class="mdc-layout-grid">
        <div id="kc-header-wrapper" class="mdc-layout-grid__inner header-container align-center">
            <div class="mdc-layout-grid__cell--span-12">
                <img src="${url.resourcesPath}/img/logo@2x.png" width="82" height="71" />
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
    <#if displayMessage && message?has_content>
<div class="mdc-layout-grid" style="max-width:550px; padding-top:0;">
    <div class="mdc-layout-grid__inner">
        <div class="mdc-layout-grid__cell--span-12 align-center">
            <div class="alert alert-${message.type}">
                <#if message.type = 'success'><i class="material-icons">check_circle</i></#if>
                <#if message.type = 'warning'><i class="material-icons">warning</i></#if>
                <#if message.type = 'error'><i class="material-icons">error</i></#if>
                <#if message.type = 'info'><i class="material-icons">info</i></#if>
                <span class="alert-text">${message.summary}</span>
            </div>
        </div>
    </div>
</div>

    </#if>
    <div class="login-content-container mdc-layout-grid">
        <div class="mdc-layout-grid__inner">
                <#nested "form">

            <#if displayInfo>
                        <#nested "info">
            </#if>
        </div>
    </div>
    <div class="bottom-container align-center">
        <div>
            <img alt="Wireframe graphic of compliance and risk dashboard Haven GRC" data-rjs="2" id="footer-lines" src="/img/footer_lines@2x.png" data-rjs-processed="true" title="" >
        </div>
        <footer class="mdc-toolbar align-center">
            <div class="mdc-toolbar__row">
                <section class="mdc-toolbar__section" style="align-items:center !important;">
                    <span>© 2017 <a href="https://kindlyops.com" title="Kindly Ops Website">KINDLY OPS</a></span>
                </section>
            </div>
        </footer>
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
