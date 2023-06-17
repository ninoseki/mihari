import { Task, useAsyncTask } from "vue-concurrency";

import { API } from "@/api";
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
  UpdateRule,
} from "@/types";

export function generateGetAlertsTask(): Task<Alerts, [AlertSearchParams]> {
  return useAsyncTask<Alerts, [AlertSearchParams]>(async (_signal, params) => {
    return await API.getAlerts(params);
  });
}

export function generateDeleteAlertTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id) => {
    return await API.deleteAlert(id);
  });
}

export function generateGetTagsTask(): Task<string[], []> {
  return useAsyncTask<string[], []>(async () => {
    return await API.getTags();
  });
}

export function generateDeleteTagTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, tag) => {
    return await API.deleteTag(tag);
  });
}

export function generateGetRuleSetTask(): Task<string[], []> {
  return useAsyncTask<string[], []>(async () => {
    return await API.getRuleSet();
  });
}

export function generateGetArtifactTask(): Task<ArtifactWithTags, [string]> {
  return useAsyncTask<ArtifactWithTags, [string]>(async (_signal, id) => {
    return await API.getArtifact(id);
  });
}

export function generateDeleteArtifactTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id) => {
    return await API.deleteArtifact(id);
  });
}

export function generateEnrichArtifactTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id) => {
    return await API.enrichArtifact(id);
  });
}

export function generateGetConfigsTask(): Task<Config[], []> {
  return useAsyncTask<Config[], []>(async () => {
    return await API.getConfigs();
  });
}

export function generateGetIPTask(): Task<IPInfo, [string]> {
  return useAsyncTask<IPInfo, [string]>(async (_signal, ipAddress: string) => {
    return await API.getIPInfo(ipAddress);
  });
}

export function generateGetRulesTask(): Task<Rules, [RuleSearchParams]> {
  return useAsyncTask<Rules, [RuleSearchParams]>(
    async (_signal, params: RuleSearchParams) => {
      return await API.getRules(params);
    }
  );
}

export function generateGetRuleTask(): Task<Rule, [string]> {
  return useAsyncTask<Rule, [string]>(async (_signal, id: string) => {
    return await API.getRule(id);
  });
}

export function generateDeleteRuleTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id: string) => {
    return await API.deleteRule(id);
  });
}

export function generateRunRuleTask(): Task<void, [string]> {
  return useAsyncTask<void, [string]>(async (_signal, id) => {
    return await API.runRule(id);
  });
}

export function generateCreateRuleTask(): Task<Rule, [CreateRule]> {
  return useAsyncTask<Rule, [CreateRule]>(async (_signal, payload) => {
    return await API.createRule(payload);
  });
}

export function generateUpdateRuleTask(): Task<Rule, [UpdateRule]> {
  return useAsyncTask<Rule, [UpdateRule]>(async (_signal, payload) => {
    return await API.updateRule(payload);
  });
}
