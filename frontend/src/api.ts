import axios from "axios";

import {
  Alerts,
  AlertSearchParams,
  ArtifactWithTags,
  Config,
  CreateRule,
  IPInfo,
  Rule,
  Rules,
  RuleSearchParams,
  RuleSet,
  Tags,
  UpdateRule,
} from "@/types";

const client = axios.create({
  headers: {
    Accept: "application/json",
  },
});

export const API = {
  async getConfigs(): Promise<Config[]> {
    const res = await client.get<Config[]>("/api/configs");
    return res.data;
  },

  async getAlerts(params: AlertSearchParams): Promise<Alerts> {
    params.page = params.page || 1;
    const res = await client.get<Alerts>("/api/alerts", {
      params: params,
    });
    return res.data;
  },

  async getTags(): Promise<string[]> {
    const res = await client.get<Tags>("/api/tags");
    return res.data.tags;
  },

  async getRuleSet(): Promise<string[]> {
    const res = await client.get<RuleSet>("/api/rules/ids");
    return res.data.ruleIds;
  },

  async deleteAlert(id: string): Promise<void> {
    await client.delete(`/api/alerts/${id}`);
  },

  async getArtifact(id: string): Promise<ArtifactWithTags> {
    const res = await client.get(`/api/artifacts/${id}`);
    return res.data;
  },

  async enrichArtifact(id: string): Promise<void> {
    await client.get(`/api/artifacts/${id}/enrich`);
    return;
  },

  async deleteArtifact(id: string): Promise<void> {
    await client.delete(`/api/artifacts/${id}`);
  },

  async getRules(params: RuleSearchParams): Promise<Rules> {
    params.page = params.page || 1;
    const res = await client.get<Rules>("/api/rules", {
      params: params,
    });
    return res.data;
  },

  async getRule(id: string): Promise<Rule> {
    const res = await client.get<Rule>(`/api/rules/${id}`);
    return res.data;
  },

  async runRule(id: string): Promise<void> {
    await client.get<void>(`/api/rules/${id}/run`);
  },

  async createRule(payload: CreateRule): Promise<Rule> {
    const res = await client.post<Rule>("/api/rules/", payload);
    return res.data;
  },

  async updateRule(payload: UpdateRule): Promise<Rule> {
    const res = await client.put<Rule>("/api/rules/", payload);
    return res.data;
  },

  async deleteRule(id: string): Promise<void> {
    await client.delete<void>(`/api/rules/${id}`);
  },

  async deleteTag(name: string): Promise<void> {
    await client.delete(`/api/tags/${name}`);
  },

  async getIPInfo(ipAddress: string): Promise<IPInfo> {
    const res = await client.get<IPInfo>(`/api/ip_addresses/${ipAddress}`);
    return res.data;
  },
};
