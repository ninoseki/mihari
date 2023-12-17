<template>
  <Loading v-if="getAlertsTask.isRunning"></Loading>
  <Alerts
    :page="page.toString()"
    :alerts="getAlertsTask.last.value"
    v-if="getAlertsTask.last?.value"
    @refresh-page="refreshPage"
    @update-page="updatePage"
  >
  </Alerts>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref, watch } from "vue"

import { generateGetAlertsTask } from "@/api-helper"
import Alerts from "@/components/alert/Alerts.vue"
import Loading from "@/components/Loading.vue"
import type { SearchParams } from "@/types"

export default defineComponent({
  name: "AlertsWithPagination",
  props: {
    ruleId: {
      type: String
    },
    artifact: {
      type: String
    }
  },
  components: {
    Alerts,
    Loading
  },
  setup(props) {
    const page = ref(1)
    const q = ref(`rule.id:${props.ruleId}`)

    const getAlertsTask = generateGetAlertsTask()

    const getAlerts = async () => {
      const params: SearchParams = {
        q: q.value,
        page: page.value
      }
      return await getAlertsTask.perform(params)
    }

    const updatePage = (newPage: number) => {
      page.value = newPage
    }

    const resetPage = () => {
      page.value = 1
    }

    const refreshPage = async () => {
      resetPage()
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
      refreshPage,
      updatePage
    }
  }
})
</script>
