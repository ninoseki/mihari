<script setup lang="ts">
import { computed, onMounted, type PropType } from "vue"

import { generateGetAlertsTask, generateGetArtifactsTask } from "@/api-helper"
import type { RuleType } from "@/schemas"

const props = defineProps({
  rule: {
    type: Object as PropType<RuleType>,
    required: true
  }
})

const q = computed(() => {
  return `rule.id:"${props.rule.id}"`
})

const getAlertsTask = generateGetAlertsTask()
const getArtifactsTask = generateGetArtifactsTask()

onMounted(() => {
  getAlertsTask.perform({ q: q.value, page: 1, limit: 0 })
  getArtifactsTask.perform({ q: q.value, page: 1, limit: 0 })
})
</script>

<template>
  <span class="buttons is-pulled-right">
    <a class="button is-small is-warning">
      <span>Alerts:</span>
      <span>{{ getAlertsTask.last?.value?.total }}</span>
    </a>
    <a class="button is-small is-success">
      <span>Artifacts:</span>
      <span>{{ getArtifactsTask.last?.value?.total }}</span>
    </a>
  </span>
</template>
