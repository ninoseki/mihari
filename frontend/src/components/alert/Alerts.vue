<template>
  <div v-if="hasAlerts">
    <Alert
      v-for="(alert, index) in alerts.results"
      :alert="alert"
      :key="index"
      @refresh-page="refreshPage"
    ></Alert>
    <Pagination
      :total="alerts.total"
      :currentPage="alerts.currentPage"
      :pageSize="alerts.pageSize"
      @update-page="updatePage"
    ></Pagination>
    <p class="help">({{ alerts.total }} results in total, {{ alerts.results.length }} shown)</p>
  </div>
  <div v-else>
    <div class="notification is-warning is-light">There is no alert to show</div>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent, type PropType } from "vue"

import Alert from "@/components/alert/Alert.vue"
import Pagination from "@/components/Pagination.vue"
import type { Alerts } from "@/types"

export default defineComponent({
  name: "AlertsItem",
  components: {
    Alert,
    Pagination
  },
  props: {
    page: {
      type: String,
      required: true
    },
    alerts: {
      type: Object as PropType<Alerts>,
      required: true
    }
  },
  emits: ["update-page", "refresh-page"],
  setup(props, context) {
    const scrollToTop = () => {
      window.scrollTo({
        top: 0
      })
    }

    const updatePage = (page: number) => {
      scrollToTop()
      context.emit("update-page", page)
    }

    const refreshPage = () => {
      scrollToTop()
      context.emit("refresh-page")
    }

    const hasAlerts = computed(() => {
      return props.alerts.results.length > 0
    })

    return { updatePage, refreshPage, hasAlerts }
  }
})
</script>
