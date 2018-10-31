package org.kindlyops.providers.rest;

import org.keycloak.connections.jpa.JpaConnectionProvider;
import org.jboss.resteasy.annotations.cache.NoCache;
import org.kindlyops.providers.OrganizationRepresentation;
import org.keycloak.models.KeycloakSession;
import org.kindlyops.providers.jpa.HavenOrganization;
import org.keycloak.models.utils.KeycloakModelUtils;

import javax.persistence.EntityManager;
import org.keycloak.models.RealmModel;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;
import java.util.LinkedList;

public class OrganizationResource {

    private final KeycloakSession session;

    public OrganizationResource(KeycloakSession session) {
        this.session = session;
        if (getRealm() == null) {
            throw new IllegalStateException("The service cannot accept a session without a realm in it's context.");
        }
    }

    private EntityManager getEntityManager() {
        return session.getProvider(JpaConnectionProvider.class).getEntityManager();
    }

    protected RealmModel getRealm() {
        return session.getContext().getRealm();
    }

    private List<OrganizationRepresentation> listOrganizations() {
        List<HavenOrganization> organizationEntities = getEntityManager()
                .createNamedQuery("findByRealm", HavenOrganization.class).setParameter("realmId", getRealm().getId())
                .getResultList();

        List<OrganizationRepresentation> result = new LinkedList<>();
        for (HavenOrganization entity : organizationEntities) {
            result.add(new OrganizationRepresentation(entity));
        }
        return result;
    }

    @GET
    @Path("")
    @NoCache
    @Produces(MediaType.APPLICATION_JSON)
    public List<OrganizationRepresentation> getOrganizations() {
        return this.listOrganizations();
    }

    @POST
    @Path("")
    @NoCache
    @Consumes(MediaType.APPLICATION_JSON)
    public Response createOrganization(OrganizationRepresentation rep) {
        this.addOrganization(rep);
        return Response.created(session.getContext().getUri().getAbsolutePathBuilder().path(rep.getId()).build())
                .build();
    }

    private OrganizationRepresentation addOrganization(OrganizationRepresentation organization) {
        HavenOrganization entity = new HavenOrganization();
        String id = organization.getId() == null ? KeycloakModelUtils.generateId() : organization.getId();
        entity.setId(id);
        entity.setName(organization.getName());
        entity.setRealmId(getRealm().getId());
        getEntityManager().persist(entity);

        organization.setId(id);
        return organization;
    }

    @GET
    @NoCache
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public OrganizationRepresentation getOrganization(@PathParam("id") final String id) {
        return this.findOrganization(id);
    }

    private OrganizationRepresentation findOrganization(String id) {
        HavenOrganization entity = getEntityManager().find(HavenOrganization.class, id);
        return entity == null ? null : new OrganizationRepresentation(entity);
    }

}