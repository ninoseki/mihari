import axios from "axios"

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
  type IpInfoType,
  MessageSchema,
  type MessageType,
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

const client = axios.create()

export const API = {
  async getConfigs(): Promise<ConfigsType> {
    const res = await client.get("/api/configs")
    return ConfigsSchema.parse(res.data)
  },

  async getAlerts(params: SearchParamsType): Promise<AlertsType> {
    params.page = params.page || 1
    const res = await client.get("/api/alerts", {
      params: params
    })
    return AlertsSchema.parse(res.data)
  },

  async getAlert(id: number): Promise<AlertType> {
    const res = await client.get(`/api/alerts/${id}`)
    return AlertSchema.parse(res.data)
  },

  async getTags(): Promise<TagsType> {
    const res = await client.get("/api/tags")
    return TagsSchema.parse(res.data)
  },

  async deleteAlert(id: number): Promise<MessageType> {
    const res = await client.delete(`/api/alerts/${id}`)
    return MessageSchema.parse(res.data)
  },

  async getArtifact(id: number): Promise<ArtifactType> {
    const res = await client.get(`/api/artifacts/${id}`)
    return ArtifactSchema.parse(res.data)
  },

  async getArtifacts(params: SearchParamsType): Promise<ArtifactsType> {
    params.page = params.page || 1
    const res = await client.get("/api/artifacts", {
      params: params
    })
    return ArtifactsSchema.parse(res.data)
  },

  async enrichArtifact(id: number): Promise<QueueMessageType> {
    const res = await client.post(`/api/artifacts/${id}/enrich`)
    return QueueMessageSchema.parse(res.data)
  },

  async deleteArtifact(id: number): Promise<MessageType> {
    const res = await client.delete(`/api/artifacts/${id}`)
    return MessageSchema.parse(res.data)
  },

  async getRules(params: SearchParamsType): Promise<RulesType> {
    params.page = params.page || 1
    const res = await client.get("/api/rules", {
      params: params
    })
    return RulesSchema.parse(res.data)
  },

  async getRule(id: string): Promise<RuleType> {
    const res = await client.get(`/api/rules/${id}`)
    return RuleSchema.parse(res.data)
  },

  async searchRule(id: string): Promise<QueueMessageType> {
    const res = await client.post(`/api/rules/${id}/search`)
    return QueueMessageSchema.parse(res.data)
  },

  async createRule(payload: CreateRuleType): Promise<RuleType> {
    const res = await client.post("/api/rules/", payload)
    return RuleSchema.parse(res.data)
  },

  async updateRule(payload: UpdateRuleType): Promise<RuleType> {
    const res = await client.put("/api/rules/", payload)
    return RuleSchema.parse(res.data)
  },

  async deleteRule(id: string): Promise<MessageType> {
    const res = await client.delete(`/api/rules/${id}`)
    return MessageSchema.parse(res.data)
  },

  async deleteTag(id: number): Promise<MessageType> {
    const res = await client.delete(`/api/tags/${id}`)
    return MessageSchema.parse(res.data)
  },

  async getIpInfo(ipAddress: string): Promise<IpInfoType> {
    const res = await client.get<IpInfoType>(`/api/ip_addresses/${ipAddress}`)
    return res.data
  }
}
