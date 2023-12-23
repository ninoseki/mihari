<template>
  <Loading v-if="getAlertsTask.isRunning"></Loading>
  <Alerts
    :page="page.toString()"
    :alerts="getAlertsTask.last.value"
    v-if="getAlertsTask.last?.value"
    @refresh-page="onRefreshPage"
    @update-page="onUpdatePage"
  >
  </Alerts>
</template>

<script lang="ts">
import { computed, defineComponent, onMounted, ref, watch } from "vue"

import { generateGetAlertsTask } from "@/api-helper"
import Alerts from "@/components/alert/Alerts.vue"
import Loading from "@/components/Loading.vue"
import type { SearchParams } from "@/types"

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
    Loading
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
      const params: SearchParams = {
        q: q.value,
        page: page.value
      }
      return await getAlertsTask.perform(params)
    }

    const onUpdatePage = (newPage: number) => {
      page.value = newPage
    }

    const onResetPage = () => {
      page.value = 1
    }

    const onRefreshPage = async () => {
      onResetPage()
      await getAlerts()
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
      onRefreshPage,
      onUpdatePage
    }
  }
})
</script>
