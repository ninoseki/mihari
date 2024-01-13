# Diagrams

## Active Record Class Diagram

```mermaid
classDiagram
  class Rule {
    string id
    string title
    string description
    json data
    datetime created_at
    datetime updated_at
  }
  Rule *-- Alert
  Rule *-- Tagging
  Rule *-- Tag

  class Alert {
    integer id
    datetime created_at
    string rule_id
  }
  Alert --* Rule
  Alert *-- Artifact
  Alert *-- Tag

  class Artifact {
    integer id
    string data
    string data_type
    string source
    string query
    json metadata
    datetime created_at
    integer alert_id
  }
  Artifact --* Alert
  Artifact *-- CPE
  Artifact *-- Vulnerability
  Artifact *-- DnsRecord
  Artifact *-- Port
  Artifact *-- ReverseDnsName
  Artifact *-- Tag
  Artifact -- AutonomousSystem
  Artifact -- Geolocation
  Artifact -- WhoisRecord
  Artifact -- Rule

  class AutonomousSystem {
    integer id
    integer number
    datetime created_at
    integer artifact_id
  }
  AutonomousSystem --* Artifact

  class Port {
    integer id
    integer number
    datetime created_at
    integer artifact_id
  }
  Port --* Artifact

  class CPE {
    integer id
    string name
    datetime created_at
    integer artifact_id
  }
  CPE --* Artifact

  class Vulnerability {
    integer id
    string name
    datetime created_at
    integer artifact_id
  }
  Vulnerability --* Artifact

  class DnsRecord {
    integer id
    string resource
    string value
    datetime created_at
    integer artifact_id
  }
  DnsRecord --* Artifact

  class ReverseDnsName {
    integer id
    string name
    datetime created_at
    integer artifact_id
  }
  ReverseDnsName --* Artifact

  class WhoisRecord {
    integer id
    string domain
    date created_on
    date updated_on
    date expires_on
    json registrar
    json contacts
    datetime created_at
    integer artifact_id
  }
  WhoisRecord --* Artifact

  class Geolocation {
    integer id
    string country
    string country_code
    datetime created_at
    integer artifact_id
  }
  Geolocation --* Artifact

  class Tag {
    integer id
    string name
    datetime created_at
  }
  Tag *-- Tagging

  class Tagging {
    integer id
    integer tag_id
    string rule_id
    datetime created_at
  }
  Tagging --* Rule
  Tagging --* Tag
```

## ER Diagram

```mermaid
erDiagram
    alerts {
        datetime created_at
        integer id PK
        varchar rule_id FK
    }

    artifacts {
        integer alert_id FK
        datetime created_at
        varchar data
        varchar data_type
        integer id PK
        json metadata
        varchar query
        varchar source
    }

    autonomous_systems {
        integer artifact_id FK
        integer number
        datetime created_at
        integer id PK
    }

    cpes {
        integer artifact_id FK
        varchar name
        datetime created_at
        integer id PK
    }

    vulnerabilities {
        integer artifact_id FK
        varchar name
        datetime created_at
        integer id PK
    }

    dns_records {
        integer artifact_id FK
        datetime created_at
        integer id PK
        varchar resource
        varchar value
    }

    geolocations {
        integer artifact_id FK
        varchar country
        varchar country_code
        datetime created_at
        integer id PK
    }

    ports {
        integer artifact_id FK
        datetime created_at
        integer id PK
        integer number
    }

    reverse_dns_names {
        integer artifact_id FK
        datetime created_at
        integer id PK
        varchar name
    }

    rules {
        datetime created_at
        json data
        varchar description
        varchar id PK
        varchar title
        datetime updated_at
    }

    taggings {
        datetime created_at
        integer id PK
        varchar rule_id
        integer tag_id
    }

    tags {
        datetime created_at
        integer id PK
        varchar name
    }

    whois_records {
        integer artifact_id FK
        json contacts
        datetime created_at
        date created_on
        varchar domain
        date expires_on
        integer id PK
        json registrar
        date updated_on
    }

    alerts }o--|| rules : "rule_id"
    artifacts }o--|| alerts : "alert_id"
    autonomous_systems }o--|| artifacts : "artifact_id"
    cpes }o--|| artifacts : "artifact_id"
    vulnerabilities }o--|| artifacts : "artifact_id"
    dns_records }o--|| artifacts : "artifact_id"
    geolocations }o--|| artifacts : "artifact_id"
    ports }o--|| artifacts : "artifact_id"
    reverse_dns_names }o--|| artifacts : "artifact_id"
    whois_records }o--|| artifacts : "artifact_id"
```
