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

<script lang="ts">
import { computed, defineComponent, onMounted, ref, watch } from "vue"

import { generateGetAlertsTask } from "@/api-helper"
import Alerts from "@/components/alert/Alerts.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"
import type { SearchParamsType } from "@/schemas"

export default defineComponent({
  name: "AlertsWithPagination",
  props: {
    ruleId: {
      type: String,
      required: true
    },
    excludeAlertId: {
      type: Number,
      required: false
    }
  },
  components: {
    Alerts,
    Loading,
    ErrorMessage
  },
  setup(props) {
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

    return {
      page,
      getAlertsTask,
      onUpdatePage
    }
  }
})
</script>
