<template>
  <div v-if="hasAlerts">
    <Alert v-for="alert in alerts.results" :alert="alert" :key="alert.id" @delete="onDelete" />
    <Pagination
      :total="alerts.total"
      :currentPage="alerts.currentPage"
      :pageSize="alerts.pageSize"
      @update-page="onUpdatePage"
    />
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
import type { AlertsType } from "@/schemas"

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
      type: Object as PropType<AlertsType>,
      required: true
    }
  },
  emits: ["update-page", "refresh"],
  setup(props, context) {
    const onUpdatePage = (page: number) => {
      context.emit("update-page", page)
    }

    const onDelete = () => {
      context.emit("refresh")
    }

    const hasAlerts = computed(() => {
      return props.alerts.results.length > 0
    })

    return { onUpdatePage, onDelete, hasAlerts }
  }
})
</script>
