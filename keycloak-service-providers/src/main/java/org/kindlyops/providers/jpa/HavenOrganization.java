
package org.kindlyops.providers.jpa;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/*
<createTable tableName="HAVEN_ORGANIZATION">
            <column name="ID" type="int" autoIncrement="true">
                <constraints primaryKey="true" nullable="false"/>
            </column>
            <column name="NAME" type="VARCHAR(255)">
                <constraints nullable="false"/>
            </column>
            <column name="REALM_ID" type="VARCHAR(36)">
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

    @Column(name = "NAME", nullable = false)
    private String name;

    @Column(name = "REALM_ID", nullable = false)
    private String realmId;

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getRealmId() {
        return realmId;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setRealmId(String realmId) {
        this.realmId = realmId;
    }
}
