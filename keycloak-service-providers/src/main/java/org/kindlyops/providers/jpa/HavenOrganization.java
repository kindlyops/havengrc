
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
@Table(name = "HAVEN_ORGANIZATION")
@NamedQueries({ @NamedQuery(name = "findByRealm", query = "from HavenOrganization where realmId = :realmId") })
public class HavenOrganization {

    @Id
    @Column(name = "ID")
    private String id;

    @Column(name = "ORGANIZATION_ID", nullable = false)
    private Integer organization;

    @Column(name = "REALM_ID", nullable = false)
    private String realmId;

    @Column(name = "ORG_ROLE_ID", nullable = false)
    private Integer orgRole;

    public String getId() {
        return id;
    }

    public String getRealmId() {
        return realmId;
    }

    public Integer getOrganization() {
        return organization;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setRealmId(String realmId) {
        this.realmId = realmId;
    }
}
