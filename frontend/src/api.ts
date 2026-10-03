import ky from "ky"

import {
  AlertSchema,
  AlertsSchema,
  type AlertsType,
  type AlertType,
  ArtifactSchema,
  ArtifactsSchema,
  type ArtifactsType,
  type ArtifactType,
  ConfigsSchema,
  type ConfigsType,
  type CreateRuleType,
  IpInfoSchema,
  type IpInfoType,
  QueueMessageSchema,
  type QueueMessageType,
  RuleSchema,
  RulesSchema,
  type RulesType,
  type RuleType,
  type SearchParamsType,
  TagsSchema,
  type TagsType,
  type UpdateRuleType
} from "@/schemas"

const client = ky.create()

export const API = {
  async getConfigs(): Promise<ConfigsType> {
    return await client.get("/api/configs").json(ConfigsSchema)
  },

  async getAlerts(params: SearchParamsType): Promise<AlertsType> {
    params.page = params.page || 1
    return await client
      .get("/api/alerts", {
        searchParams: params as Record<string, string | number | boolean>
      })
      .json(AlertsSchema)
  },

  async getAlert(id: number): Promise<AlertType> {
    return await client.get(`/api/alerts/${id}`).json(AlertSchema)
  },

  async getTags(): Promise<TagsType> {
    return await client.get("/api/tags").json(TagsSchema)
  },

  async deleteAlert(id: number): Promise<void> {
    await client.delete(`/api/alerts/${id}`)
  },

  async getArtifact(id: number): Promise<ArtifactType> {
    return await client.get(`/api/artifacts/${id}`).json(ArtifactSchema)
  },

  async getArtifacts(params: SearchParamsType): Promise<ArtifactsType> {
    params.page = params.page || 1
    return await client
      .get("/api/artifacts", {
        searchParams: params as Record<string, string | number | boolean>
      })
      .json(ArtifactsSchema)
  },

  async enrichArtifact(id: number): Promise<QueueMessageType> {
    return await client.post(`/api/artifacts/${id}/enrich`).json(QueueMessageSchema)
  },

  async deleteArtifact(id: number): Promise<void> {
    await client.delete(`/api/artifacts/${id}`)
  },

  async getRules(params: SearchParamsType): Promise<RulesType> {
    params.page = params.page || 1
    return await client
      .get("/api/rules", {
        searchParams: params as Record<string, string | number | boolean>
      })
      .json(RulesSchema)
  },

  async getRule(id: string): Promise<RuleType> {
    return await client.get(`/api/rules/${id}`).json(RuleSchema)
  },

  async searchRule(id: string): Promise<QueueMessageType> {
    return await client.post(`/api/rules/${id}/search`).json(QueueMessageSchema)
  },

  async createRule(payload: CreateRuleType): Promise<RuleType> {
    return await client.post("/api/rules/", { json: payload }).json(RuleSchema)
  },

  async updateRule(payload: UpdateRuleType): Promise<RuleType> {
    return await client.put("/api/rules/", { json: payload }).json(RuleSchema)
  },

  async deleteRule(id: string): Promise<void> {
    await client.delete(`/api/rules/${id}`)
  },

  async deleteTag(id: number): Promise<void> {
    await client.delete(`/api/tags/${id}`)
  },

  async getIpInfo(ipAddress: string): Promise<IpInfoType> {
    return await client.get(`/api/ip_addresses/${ipAddress}`).json(IpInfoSchema)
  }
}
