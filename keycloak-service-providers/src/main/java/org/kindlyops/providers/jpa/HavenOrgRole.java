
package org.kindlyops.providers.jpa;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/*
        <createTable tableName="HAVEN_ORG_ROLE">
            <column name="ID" type="int", autoIncrement="true">
                <constraints primaryKey="true" nullable="false"/>
            </column>
            <column name="ORGANIZATION_ID" type="int">
                <constraints nullable="false"/>
            </column>
            <column name="ROLE" type="VARCHAR(36)">
                <constraints nullable="false"/>
            </column>
        </createTable>
*/

@Entity
@Table(name = "HAVEN_ORG_ROLE")
@NamedQueries({ @NamedQuery(name = "findByRole", query = "from HavenOrgRole where role = :role") })
public class HavenOrgRole {

    @Id
    @Column(name = "ID")
    private String id;

    @Column(name = "ORGANIZATION_ID", nullable = false)
    private Integer organization;

    @Column(name = "ROLE", nullable = false)
    private String role;

    public String getId() {
        return id;
    }

    public String getRole() {
        return role;
    }

    public Integer getOrganization() {
        return organization;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
