import { type Task, useAsyncTask } from "vue-concurrency"

import { API } from "@/api"
import type {
  AlertsType,
  AlertType,
  ArtifactsType,
  ArtifactType,
  ConfigsType,
  CreateRuleType,
  IpInfoType,
  MessageType,
  QueueMessageType,
  RulesType,
  RuleType,
  SearchParamsType,
  TagsType,
  UpdateRuleType
} from "@/schemas"

export function generateGetAlertsTask(): Task<AlertsType, [SearchParamsType]> {
  return useAsyncTask<AlertsType, [SearchParamsType]>(async (_signal, params) => {
    return await API.getAlerts(params)
  })
}

export function generateDeleteAlertTask(): Task<MessageType, [number]> {
  return useAsyncTask<MessageType, [number]>(async (_signal, id) => {
    return await API.deleteAlert(id)
  })
}

export function generateGetTagsTask(): Task<TagsType, []> {
  return useAsyncTask<TagsType, []>(async () => {
    return await API.getTags()
  })
}

export function generateDeleteTagTask(): Task<MessageType, [number]> {
  return useAsyncTask<MessageType, [number]>(async (_signal, tag) => {
    return await API.deleteTag(tag)
  })
}

export function generateGetArtifactTask(): Task<ArtifactType, [number]> {
  return useAsyncTask<ArtifactType, [number]>(async (_signal, id) => {
    return await API.getArtifact(id)
  })
}

export function generateDeleteArtifactTask(): Task<MessageType, [number]> {
  return useAsyncTask<MessageType, [number]>(async (_signal, id) => {
    return await API.deleteArtifact(id)
  })
}

export function generateEnrichArtifactTask(): Task<QueueMessageType, [number]> {
  return useAsyncTask<QueueMessageType, [number]>(async (_signal, id) => {
    return await API.enrichArtifact(id)
  })
}

export function generateGetConfigsTask(): Task<ConfigsType, []> {
  return useAsyncTask<ConfigsType, []>(async () => {
    return await API.getConfigs()
  })
}

export function generateGetIPTask(): Task<IpInfoType, [string]> {
  return useAsyncTask<IpInfoType, [string]>(async (_signal, ipAddress: string) => {
    return await API.getIpInfo(ipAddress)
  })
}

export function generateGetRulesTask(): Task<RulesType, [SearchParamsType]> {
  return useAsyncTask<RulesType, [SearchParamsType]>(async (_signal, params: SearchParamsType) => {
    return await API.getRules(params)
  })
}

export function generateGetRuleTask(): Task<RuleType, [string]> {
  return useAsyncTask<RuleType, [string]>(async (_signal, id: string) => {
    return await API.getRule(id)
  })
}

export function generateDeleteRuleTask(): Task<MessageType, [string]> {
  return useAsyncTask<MessageType, [string]>(async (_signal, id: string) => {
    return await API.deleteRule(id)
  })
}

export function generateSearchRuleTask(): Task<QueueMessageType, [string]> {
  return useAsyncTask<QueueMessageType, [string]>(async (_signal, id) => {
    return await API.searchRule(id)
  })
}

export function generateCreateRuleTask(): Task<RuleType, [CreateRuleType]> {
  return useAsyncTask<RuleType, [CreateRuleType]>(async (_signal, payload) => {
    return await API.createRule(payload)
  })
}

export function generateUpdateRuleTask(): Task<RuleType, [UpdateRuleType]> {
  return useAsyncTask<RuleType, [UpdateRuleType]>(async (_signal, payload) => {
    return await API.updateRule(payload)
  })
}

export function generateGetArtifactsTask(): Task<ArtifactsType, [SearchParamsType]> {
  return useAsyncTask<ArtifactsType, [SearchParamsType]>(async (_signal, params) => {
    return await API.getArtifacts(params)
  })
}

export function generateGetAlertTask(): Task<AlertType, [number]> {
  return useAsyncTask<AlertType, [number]>(async (_signal, id) => {
    return await API.getAlert(id)
  })
}
