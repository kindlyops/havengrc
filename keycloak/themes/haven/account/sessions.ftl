<#import "template.ftl" as layout>
    <@layout.mainLayout active='sessions' bodyClass='sessions' ; section>

        <div class="mdc-layout-grid heading">
            <div class="mdc-layout-grid__inner">
                <h2 class="mdc-layout-grid__cell--span-8">${msg("sessionsHtmlTitle")}</h2>
            </div>
        </div>

        <div class="mdc-layout-grid">
            <div class="mdc-layout-grid__inner container-margin">
                <div class="mdc-layout-grid__cell--span-12 table-scroll">
                    <table class="table table-striped table-bordered table-hover" id="SessionsTable">
                        <thead>
                            <tr>
                                <td>${msg("ip")}</td>
                                <td>${msg("started")}</td>
                                <td>${msg("lastAccess")}</td>
                                <td>${msg("expires")}</td>
                                <td>${msg("clients")}</td>
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
                                            ${client}<br />
                                        </#list>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>

                    </table>
                </div>
                <div class="mdc-layout-grid__cell">
                    <a id="logout-all-sessions" href="${url.sessionsUrl}">${msg("doLogOutAllSessions")}</a>
                </div>
            </div>
        </div>



    </@layout.mainLayout>
