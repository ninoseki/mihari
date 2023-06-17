export interface Pagination {
  total: number;
  currentPage: number;
  pageSize: number;
}

export interface ConfigValue {
  key: string;
  value: string | null;
}

export interface Config {
  name: string;
  isConfigured: boolean;
  values: ConfigValue[];
  type: string;
}

export interface Tag {
  name: string;
}

export interface Tags {
  tags: string[];
}

export interface RuleSet {
  ruleIds: string[];
}

export interface DnsRecord {
  resource: string;
  value: string;
}

export interface Contact {
  name: string | null;
  organization: string | null;
}

export interface Registrar {
  name: string | null;
  organization: string | null;
}

export interface WhoisRecord {
  createdOn: Date | null;
  updatedOn: Date | null;
  expiresOn: Date | null;
  registrar: Registrar | null;
  contacts: Contact[];
}

export interface AutonomousSystem {
  asn: number;
}

export interface Geolocation {
  country: string;
  countryCode: string;
}

export interface ReverseDnsName {
  name: string;
}

export interface CPE {
  cpe: string;
}

export interface Port {
  port: string;
}

export interface Artifact {
  id: string;
  data: string;
  dataType: string;
  source: string;
  metadata: unknown | null;
  createdAt: string;

  autonomousSystem: AutonomousSystem | null;
  whoisRecord: WhoisRecord | null;
  geolocation: Geolocation | null;

  dnsRecords: DnsRecord[] | null;
  reverseDnsNames: ReverseDnsName[] | null;
  cpes: CPE[] | null;
  ports: Port[] | null;
}

export interface ArtifactWithTags extends Artifact {
  tags: string[];
}

export interface Alert {
  id: string;
  ruleId: string;
  createdAt: string;

  tags: Tag[];
  artifacts: Artifact[];
}

export interface Alerts extends Pagination {
  alerts: Alert[];
}

export interface PaginationParams {
  page: number | undefined;
}

export interface AlertSearchParams extends PaginationParams {
  artifact: string | undefined;
  ruleId: string | undefined;
  tag: string | undefined;
  fromAt: string | undefined;
  toAt: string | undefined;
}

export interface IPInfo {
  ip: string;
  hostname: string | null;
  loc: string;
  countryCode: string;
  asn: string;
}

export interface GCS {
  lat: number;
  long: number;
}

export interface Country {
  name: string;
  code: string;
  lat: number;
  long: number;
}

export type LinkType = "ip" | "domain" | "url" | "hash";

export interface Link {
  name: string;
  type: string;
  baseURL: string;
  // eslint-disable-next-line no-unused-vars
  href(data: string): string;
  favicon(): string;
}

export interface Rule {
  id: string;
  title: string;
  description: string;
  yaml: string;
  createdAt: string;
  updatedAt: string;
  tags: Tag[];
}

export interface CreateRule {
  yaml: string;
}

export interface UpdateRule {
  id: string;
  yaml: string;
}

export interface Query {
  analyzer: string;
  query: string;
  interval: null;
}

export interface Rules extends Pagination {
  rules: Rule[];
}

export interface RuleSearchParams extends PaginationParams {
  description: string | undefined;
  tag: string | undefined;
  title: string | undefined;
  fromAt: string | undefined;
  toAt: string | undefined;
}
