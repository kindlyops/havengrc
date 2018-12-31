package org.kindlyops.providers.rest;

import org.keycloak.connections.jpa.JpaConnectionProvider;
import org.jboss.resteasy.annotations.cache.NoCache;
import org.kindlyops.providers.MembershipRepresentation;
import org.keycloak.models.KeycloakSession;
import org.kindlyops.providers.jpa.HavenMembership;
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

public class MembershipResource {

    private final KeycloakSession session;

    public MembershipResource(KeycloakSession session) {
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

    private List<MembershipRepresentation> listMemberships() {
        List<HavenMembership> membershipEntities = getEntityManager()
                .createNamedQuery("findByRealm", HavenMembership.class).setParameter("realmId", getRealm().getId())
                .getResultList();

        List<MembershipRepresentation> result = new LinkedList<>();
        for (HavenMembership entity : membershipEntities) {
            result.add(new MembershipRepresentation(entity));
        }
        return result;
    }

    @GET
    @Path("")
    @NoCache
    @Produces(MediaType.APPLICATION_JSON)
    public List<MembershipRepresentation> getMemberships() {
        return this.listMemberships();
    }

    @POST
    @Path("")
    @NoCache
    @Consumes(MediaType.APPLICATION_JSON)
    public Response createOrganization(MembershipRepresentation rep) {
        this.addMembership(rep);
        return Response.created(session.getContext().getUri().getAbsolutePathBuilder().path(rep.getId()).build())
                .build();
    }

    private MembershipRepresentation addMembership(MembershipRepresentation membership) {
        HavenMembership entity = new HavenMembership();
        entity.setOrgRole(membership.getRole());
        entity.setRealmId(getRealm().getId());
        getEntityManager().persist(entity);

        membership.setId(entity.getId().toString());
        return membership;
    }

    @GET
    @NoCache
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public MembershipRepresentation getMembership(@PathParam("id") final Integer id) {
        return this.findMembership(id);
    }

    private MembershipRepresentation findMembership(Integer id) {
        HavenMembership entity = getEntityManager().find(HavenMembership.class, id);
        return entity == null ? null : new MembershipRepresentation(entity);
    }

}