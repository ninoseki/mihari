import { type Task, useAsyncTask } from "vue-concurrency"

import { API } from "@/api"
import type {
  Alerts,
  ArtifactWithTags,
  Config,
  CreateRule,
  IPInfo,
  Rule,
  Rules,
  SearchParams,
  UpdateRule
} from "@/types"

export function generateGetAlertsTask(): Task<Alerts, [SearchParams]> {
  return useAsyncTask<Alerts, [SearchParams]>(async (_signal, params) => {
    return await API.getAlerts(params)
  })
}

export function generateDeleteAlertTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id) => {
    return await API.deleteAlert(id)
  })
}

export function generateGetTagsTask(): Task<string[], []> {
  return useAsyncTask<string[], []>(async () => {
    return await API.getTags()
  })
}

export function generateDeleteTagTask(): Task<void, [number]> {
  return useAsyncTask<void, [number]>(async (_signal, tag) => {
    return await API.deleteTag(tag)
  })
}

export function generateGetArtifactTask(): Task<ArtifactWithTags, [string]> {
  return useAsyncTask<ArtifactWithTags, [string]>(async (_signal, id) => {
    return await API.getArtifact(id)
  })
}

export function generateDeleteArtifactTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id) => {
    return await API.deleteArtifact(id)
  })
}

export function generateEnrichArtifactTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id) => {
    return await API.enrichArtifact(id)
  })
}

export function generateGetConfigsTask(): Task<Config[], []> {
  return useAsyncTask<Config[], []>(async () => {
    return await API.getConfigs()
  })
}

export function generateGetIPTask(): Task<IPInfo, [string]> {
  return useAsyncTask<IPInfo, [string]>(async (_signal, ipAddress: string) => {
    return await API.getIPInfo(ipAddress)
  })
}

export function generateGetRulesTask(): Task<Rules, [SearchParams]> {
  return useAsyncTask<Rules, [SearchParams]>(async (_signal, params: SearchParams) => {
    return await API.getRules(params)
  })
}

export function generateGetRuleTask(): Task<Rule, [string]> {
  return useAsyncTask<Rule, [string]>(async (_signal, id: string) => {
    return await API.getRule(id)
  })
}

export function generateDeleteRuleTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id: string) => {
    return await API.deleteRule(id)
  })
}

export function generateSearchRuleTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id) => {
    return await API.searchRule(id)
  })
}

export function generateCreateRuleTask(): Task<Rule, [CreateRule]> {
  return useAsyncTask<Rule, [CreateRule]>(async (_signal, payload) => {
    return await API.createRule(payload)
  })
}

export function generateUpdateRuleTask(): Task<Rule, [UpdateRule]> {
  return useAsyncTask<Rule, [UpdateRule]>(async (_signal, payload) => {
    return await API.updateRule(payload)
  })
}
