# Censys Platform API (Version 3)

> Need the legacy Search API? See [Censys Search API (Version 2)](censys.md).

The unified `censys` analyzer can query the new [Censys Platform API](https://docs.censys.com/reference/get-started#/) when you set `options.version: 3`. Use a Personal Access Token (PAT) plus optional organization ID.

```yaml
analyzer: censys
query: 'host.services.software.product="Cobalt Strike"'
options:
  version: 3
api_key: "censys_pat"          # or use the CENSYS_V3_API_KEY env var
organization_id: "org-xxxx"    # optional, maps to CENSYS_V3_ORG_ID
```

## Credentials

| Field | Env var | Notes |
| --- | --- | --- |
| `api_key` | `CENSYS_V3_API_KEY` (falls back to `CENSYS_V2_API_KEY`) | Required PAT |
| `organization_id` | `CENSYS_V3_ORG_ID` (falls back to `CENSYS_V2_ORG_ID`) | Optional; only needed for certain subscriptions |

## Returned Artifacts

Responses mirror the legacy analyzer—they include the matched IP/domain along with attached service metadata (ports, protocols, TLS, AS info, geolocation, etc.). The raw Platform document is stored in the artifact's `metadata` field for downstream enrichment.

## Tips

- Mihari still defaults to version 2 for backward compatibility. Set `options.version: 3` explicitly in rules to avoid the deprecation warning.
- Only the PAT path honors `api_key` + `organization_id`. The legacy `id`/`secret` parameters are ignored when `version: 3` is specified.
