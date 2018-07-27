
package org.kindlyops.providers.jpa;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/*
        <createTable tableName="HAVEN_MEMBERSHIP">
            <column name="ID" type="int", autoIncrement="true">
                <constraints primaryKey="true" nullable="false"/>
            </column>
            <column name="ORGANIZATION_ID" type="int">
                <constraints nullable="false"/>
            </column>
            <column name="REALM_ID" type="VARCHAR(36)">
                <constraints nullable="false"/>
            </column>
            <column name="ORG_ROLE_ID" type="int">
                <constraints nullable="false"/>
            </column>
        </createTable>
*/

@Entity
@Table(name = "HAVEN_MEMBERSHIP")
public class HavenMembership {

    @Id
    @Column(name = "ID", nullable = false)
    private Integer id;

    @Column(name = "ORGANIZATION_ID", nullable = false)
    private Integer organizationId;

    @Column(name = "REALM_ID", nullable = false)
    private String realmId;

    @Column(name = "ORG_ROLE_ID", nullable = false)
    private Integer orgRoleId;

    public Integer getId() {
        return id;
    }

    public Integer getOrganizationId() {
        return organizationId;
    }

    public String getRealmId() {
        return realmId;
    }

    public Integer getOrgRoleId() {
        return orgRoleId;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public void setOrganizationId(Integer id) {
        this.organizationId = id;
    }

    public void setRealmId(String realmId) {
        this.realmId = realmId;
    }

    public void setOrgRoleId(Integer roleId) {
        this.orgRoleId = roleId;
    }
}
