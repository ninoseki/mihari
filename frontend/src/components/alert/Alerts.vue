<template>
  <Alert
    v-for="(alert, index) in alerts.alerts"
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
  <p class="help">({{ alerts.total }} results in total, {{ alerts.alerts.length }} shown)</p>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

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
  setup(_, context) {
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

    return { updatePage, refreshPage }
  }
})
</script>
