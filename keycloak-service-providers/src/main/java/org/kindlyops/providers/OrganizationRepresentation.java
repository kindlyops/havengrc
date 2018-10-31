package org.kindlyops.providers;

import org.kindlyops.providers.jpa.HavenOrganization;

public class OrganizationRepresentation {

    private String id;
    private String name;

    public OrganizationRepresentation() {
    }

    public OrganizationRepresentation(HavenOrganization organization) {
        id = organization.getId();
        name = organization.getName();
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }
}