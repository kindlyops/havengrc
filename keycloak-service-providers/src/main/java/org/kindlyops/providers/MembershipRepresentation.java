package org.kindlyops.providers;

import org.kindlyops.providers.jpa.HavenMembership;

public class MembershipRepresentation {

    private String id;
    private String role;

    public MembershipRepresentation() {
    }

    public MembershipRepresentation(HavenMembership membership) {
        id = membership.getId().toString();
        role = membership.getOrgRole();
    }

    public String getId() {
        return id;
    }

    public String getRole() {
        return role;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setRole(String role) {
        this.role = role;
    }
}