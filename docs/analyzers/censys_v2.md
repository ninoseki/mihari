# Censys V2 Analyzer

This analyzer uses the [Censys Platform API](https://docs.censys.com/reference/get-started#/) via Personal Access Token and supports organization-scoped queries.

```yaml
analyzer: censys_v2
query: ...
api_key: "your_censys_pat"         # or set CENSYS_V2_API_KEY in your environment
organization_id: "org-xxxx-yyyy"   # if applicable
```

## Returns fields

- data (IP address): host_v1.resource.ip
- autonomous_system: host_v1.resource.autonomous_system
- geolocation: host_v1.resource.location
- ports: host_v1.resource.services[*].port
- metadata: full hit object

## Setup

Add your API key as CENSYS_V2_API_KEY in the environment, optionally CENSYS_V2_ORG_ID.