import { z } from "zod"

export const PaginationSchema = z.object({
  total: z.number(),
  currentPage: z.number(),
  pageSize: z.number()
})

export const ConfigItemSchema = z.object({
  key: z.string(),
  value: z.string().nullish()
})

export const ConfigSchema = z.object({
  name: z.string(),
  configured: z.boolean(),
  items: z.array(ConfigItemSchema).nullish(),
  type: z.string()
})

export const ConfigsSchema = z.object({
  results: z.array(ConfigSchema)
})

export const TagSchema = z.object({
  id: z.number(),
  name: z.string()
})

export const TagsSchema = PaginationSchema.extend({
  results: z.array(TagSchema)
})

export const DnsRecordSchema = z.object({
  resource: z.string(),
  value: z.string()
})

export const ContactSchema = z.object({
  name: z.string().nullish(),
  organization: z.string().nullish()
})

export const WhoisRecordSchema = z.object({
  createdOn: z.string().nullish(),
  updatedOn: z.string().nullish(),
  expiresOn: z.string().nullish(),
  registrar: ContactSchema.nullish(),
  contacts: z.array(ConfigItemSchema)
})

export const AutonomousSystemSchema = z.object({
  number: z.number()
})

export const GeolocationSchema = z.object({
  country: z.string(),
  countryCode: z.string()
})

export const ReverseDnsNameSchema = z.object({
  name: z.string()
})

export const CpeSchema = z.object({
  name: z.string()
})

export const VulnerabilitySchema = z.object({
  name: z.string()
})

export const PortSchema = z.object({
  number: z.number()
})

export const ArtifactSchema = z.object({
  id: z.number(),
  data: z.string(),
  dataType: z.string(),
  source: z.string(),
  query: z.string().nullish(),
  metadata: z.any().nullish(),
  createdAt: z.string(),
  autonomousSystem: AutonomousSystemSchema.nullish(),
  whoisRecord: WhoisRecordSchema.nullish(),
  geolocation: GeolocationSchema.nullish(),
  dnsRecords: z.array(DnsRecordSchema).nullish(),
  reverseDnsNames: z.array(ReverseDnsNameSchema).nullish(),
  cpes: z.array(CpeSchema).nullish(),
  ports: z.array(PortSchema).nullish(),
  vulnerabilities: z.array(VulnerabilitySchema).nullish(),
  tags: z.array(TagSchema)
})

export const AlertSchema = z.object({
  id: z.number(),
  ruleId: z.string(),
  createdAt: z.string(),
  tags: z.array(TagSchema),
  artifacts: z.array(ArtifactSchema)
})

export const AlertsSchema = PaginationSchema.extend({
  results: z.array(AlertSchema)
})

export const SearchParamsSchema = z.object({
  q: z.string(),
  page: z.number().nullish(),
  limit: z.number().nullish()
})

export const IpInfoSchema = z.object({
  countryCode: z.string(),
  asn: z.string().nullish(),
  loc: z.string().nullish()
})

export const GcsSchema = z.object({
  lat: z.number(),
  long: z.number()
})

export const CountrySchema = z.object({
  name: z.string(),
  code: z.string(),
  lat: z.number(),
  long: z.number()
})

export const LinkTypeSchema = z.union([
  z.literal("ip"),
  z.literal("domain"),
  z.literal("url"),
  z.literal("hash"),
  z.literal("mail")
])

export const LinkSchema = z.object({
  name: z.string(),
  type: z.string(),
  baseURL: z.string(),
  favicon: z.function().returns(z.string()),
  href: z.function().args(z.string()).returns(z.string())
})

export const RuleSchema = z.object({
  id: z.string(),
  title: z.string(),
  description: z.string(),
  yaml: z.string(),
  createdAt: z.string(),
  updatedAt: z.string(),
  tags: z.array(TagSchema)
})

export const CreateRuleSchema = z.object({
  yaml: z.string()
})

export const UpdateRuleSchema = z.object({
  yaml: z.string()
})

export const QuerySchema = z.object({
  analyzer: z.string(),
  query: z.string()
})

export const RulesSchema = PaginationSchema.extend({
  results: z.array(RuleSchema)
})

export const ArtifactsSchema = PaginationSchema.extend({
  results: z.array(ArtifactSchema)
})

export const MessageSchema = z.object({
  message: z.string()
})

export const ErrorMessageSchema = MessageSchema.extend({
  detail: z.any().nullish()
})

export const QueueMessageSchema = MessageSchema.extend({
  queued: z.boolean()
})

export const NavigateToSchema = z.union([
  z.literal("Alerts"),
  z.literal("Rules"),
  z.literal("Artifacts")
])

export type PaginationType = z.infer<typeof PaginationSchema>
export type ConfigItemType = z.infer<typeof ConfigItemSchema>
export type ConfigType = z.infer<typeof ConfigSchema>
export type ConfigsType = z.infer<typeof ConfigsSchema>
export type TagType = z.infer<typeof TagSchema>
export type DnsRecordType = z.infer<typeof DnsRecordSchema>
export type ContactType = z.infer<typeof ContactSchema>
export type WhoisRecordType = z.infer<typeof WhoisRecordSchema>
export type AutonomousSystemType = z.infer<typeof AutonomousSystemSchema>
export type GeolocationType = z.infer<typeof GeolocationSchema>
export type ReverseDnsNameType = z.infer<typeof ReverseDnsNameSchema>
export type CpeType = z.infer<typeof CpeSchema>
export type VulnerabilityType = z.infer<typeof VulnerabilitySchema>
export type PortType = z.infer<typeof PortSchema>
export type ArtifactType = z.infer<typeof ArtifactSchema>
export type AlertType = z.infer<typeof AlertSchema>
export type SearchParamsType = z.infer<typeof SearchParamsSchema>
export type IpInfoType = z.infer<typeof IpInfoSchema>
export type GcsType = z.infer<typeof GcsSchema>
export type CountryType = z.infer<typeof CountrySchema>
export type LinkType = z.infer<typeof LinkSchema>
export type RuleType = z.infer<typeof RuleSchema>
export type CreateRuleType = z.infer<typeof CreateRuleSchema>
export type UpdateRuleType = z.infer<typeof UpdateRuleSchema>
export type QueryType = z.infer<typeof QuerySchema>
export type MessageType = z.infer<typeof MessageSchema>
export type TagsType = z.infer<typeof TagsSchema>
export type AlertsType = z.infer<typeof AlertsSchema>
export type RulesType = z.infer<typeof RulesSchema>
export type ArtifactsType = z.infer<typeof ArtifactsSchema>
export type ErrorMessageType = z.infer<typeof ErrorMessageSchema>
export type QueueMessageType = z.infer<typeof QueueMessageSchema>

export type LinkTypeType = z.infer<typeof LinkTypeSchema>
export type NavigateToType = z.infer<typeof NavigateToSchema>
