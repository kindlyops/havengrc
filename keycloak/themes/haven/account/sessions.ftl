<#import "template.ftl" as layout>
  <@layout.mainLayout active='sessions' bodyClass='sessions' ; section>

    <div class="heading py-3 mb-3">
      <h2>${msg("sessionsHtmlTitle")}</h2>
      <span class="subtitle">
        <span class="required">*</span>
        ${msg("requiredFields")}
      </span>
    </div>

    <div class="px-4">
      <div class="table-responsive">
        <table class="table table-hover table-bordered table-sm" id="TotpTable">
          <thead>
            <tr>
              <th>${msg("ip")}</th>
              <th>${msg("started")}</th>
              <th>${msg("lastAccess")}</th>
              <th>${msg("expires")}</th>
              <th>${msg("clients")}</th>
            </tr>
          </thead>
          <tbody>
            <#list sessions.sessions as session>
                <tr>
                  <td>${session.ipAddress}</td>
                  <td>${session.started?datetime}</td>
                  <td>${session.lastAccess?datetime}</td>
                  <td>${session.expires?datetime}</td>
                  <td>
                      <#list session.clients as client>
                          ${client}<br/>
                      </#list>
                  </td>
                </tr>
            </#list>
          </tbody>
        </table>
      </div>
      <form action="${url.sessionsUrl}" method="post">
         <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker}">
         <button id="logout-all-sessions" class="btn btn-flat-secondary">${msg("doLogOutAllSessions")}</button>
      </form>
    </div>
  </@layout.mainLayout>
