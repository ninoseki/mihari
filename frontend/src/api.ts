import axios from "axios"

import type {
  Alert,
  Alerts,
  Artifact,
  Artifacts,
  Config,
  CreateRule,
  IPInfo,
  Message,
  QueueMessage,
  Rule,
  Rules,
  SearchParams,
  Tags,
  UpdateRule
} from "@/types"

const client = axios.create()

export const API = {
  async getConfigs(): Promise<Config[]> {
    const res = await client.get<Config[]>("/api/configs")
    return res.data
  },

  async getAlerts(params: SearchParams): Promise<Alerts> {
    params.page = params.page || 1
    const res = await client.get<Alerts>("/api/alerts", {
      params: params
    })
    return res.data
  },

  async getAlert(id: number): Promise<Alert> {
    const res = await client.get<Alert>(`/api/alerts/${id}`)
    return res.data
  },

  async getTags(): Promise<Tags> {
    const res = await client.get<Tags>("/api/tags")
    return res.data
  },

  async deleteAlert(id: number): Promise<Message> {
    const res = await client.delete<Message>(`/api/alerts/${id}`)
    return res.data
  },

  async getArtifact(id: number): Promise<Artifact> {
    const res = await client.get<Artifact>(`/api/artifacts/${id}`)
    return res.data
  },

  async getArtifacts(params: SearchParams): Promise<Artifacts> {
    params.page = params.page || 1
    const res = await client.get<Artifacts>("/api/artifacts", {
      params: params
    })
    return res.data
  },

  async enrichArtifact(id: number): Promise<QueueMessage> {
    const res = await client.post<QueueMessage>(`/api/artifacts/${id}/enrich`)
    return res.data
  },

  async deleteArtifact(id: number): Promise<Message> {
    const res = await client.delete<Message>(`/api/artifacts/${id}`)
    return res.data
  },

  async getRules(params: SearchParams): Promise<Rules> {
    params.page = params.page || 1
    const res = await client.get<Rules>("/api/rules", {
      params: params
    })
    return res.data
  },

  async getRule(id: string): Promise<Rule> {
    const res = await client.get<Rule>(`/api/rules/${id}`)
    return res.data
  },

  async searchRule(id: string): Promise<QueueMessage> {
    const res = await client.post<QueueMessage>(`/api/rules/${id}/search`)
    return res.data
  },

  async createRule(payload: CreateRule): Promise<Rule> {
    const res = await client.post<Rule>("/api/rules/", payload)
    return res.data
  },

  async updateRule(payload: UpdateRule): Promise<Rule> {
    const res = await client.put<Rule>("/api/rules/", payload)
    return res.data
  },

  async deleteRule(id: string): Promise<Message> {
    const res = await client.delete<Message>(`/api/rules/${id}`)
    return res.data
  },

  async deleteTag(id: number): Promise<Message> {
    const res = await client.delete<Message>(`/api/tags/${id}`)
    return res.data
  },

  async getIPInfo(ipAddress: string): Promise<IPInfo> {
    const res = await client.get<IPInfo>(`/api/ip_addresses/${ipAddress}`)
    return res.data
  }
}
