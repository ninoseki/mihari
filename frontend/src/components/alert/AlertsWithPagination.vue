<script setup lang="ts">
import { computed, onMounted, ref, watch } from "vue"

import { generateGetAlertsTask } from "@/api-helper"
import Alerts from "@/components/alert/AlertsItem.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/LoadingItem.vue"
import type { SearchParamsType } from "@/schemas"

const props = defineProps({
  ruleId: {
    type: String,
    required: true
  },
  excludeAlertId: {
    type: Number,
    required: false
  }
})

const page = ref(1)
const q = computed(() => {
  if (!props.excludeAlertId) {
    return `rule.id:"${props.ruleId}"`
  }
  return `rule.id:"${props.ruleId}" AND NOT id:${props.excludeAlertId}`
})

const getAlertsTask = generateGetAlertsTask()

const getAlerts = async () => {
  const params: SearchParamsType = {
    q: q.value,
    page: page.value
  }
  return await getAlertsTask.perform(params)
}

const onUpdatePage = (newPage: number) => {
  page.value = newPage
}

onMounted(async () => {
  await getAlerts()
})

watch([props, page], async () => {
  await getAlerts()
})
</script>

<template>
  <Loading v-if="getAlertsTask.isRunning" />
  <ErrorMessage v-if="getAlertsTask.isError" :error="getAlertsTask.last?.error" />
  <Alerts
    :page="page.toString()"
    :alerts="getAlertsTask.last.value"
    v-if="getAlertsTask.last?.value"
    @update-page="onUpdatePage"
  />
</template>
