<#import "template.ftl" as layout>
<@layout.mainLayout active='social' bodyClass='social'; section>

<div class="heading py-3 mb-3">
  <h2>${msg("federatedIdentitiesHtmlTitle")}</h2>
</div>

    <div id="federated-identities">
    <#list federatedIdentity.identities as identity>
            <#if identity.connected>
                <#if federatedIdentity.removeLinkPossible>
                    <form action="${url.socialUrl}" method="post" class="px-4">
                      <div class="form-row pb-3">
                        <div class="col-sm-10">
                          <label for="${identity.providerId!}" class="">${identity.displayName!}</label>
                          <input disabled="true" class="form-control" value="${identity.userName!}">
                          <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker}">
                          <input type="hidden" id="action" name="action" value="remove">
                          <input type="hidden" id="providerId" name="providerId" value="${identity.providerId!}">
                        </div>
                        <div class="col-sm-2 pt-2 d-flex align-items-end justify-content-end">
                          <button id="remove-link-${identity.providerId!}" class="btn btn-secondary">${msg("doRemove")}</button>
                        </div>
                      </div>
                    </form>
                </#if>
            <#else>
            <form action="${url.socialUrl}" method="post" class="px-4">
                  <div class="form-row pb-3">
                    <div class="col-sm-10">
                      <label for="${identity.providerId!}" class="">${identity.displayName!}</label>
                      <input disabled="true" class="form-control" value="${identity.userName!}">
                      <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker}">
                      <input type="hidden" id="action" name="action" value="add">
                      <input type="hidden" id="providerId" name="providerId" value="${identity.providerId!}">
                    </div>
                    <div class="col-sm-2 pt-2 d-flex align-items-end justify-content-end">
                      <button id="add-link-${identity.providerId!}" class="btn btn-secondary">${msg("doAdd")}</button>
                    </div>
                  </div>
                </form>
            </#if>
    </#list>
    </div>

</@layout.mainLayout>
