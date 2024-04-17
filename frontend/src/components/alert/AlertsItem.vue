<script setup lang="ts">
import { computed, type PropType } from "vue"

import Alert from "@/components/alert/AlertItem.vue"
import Pagination from "@/components/PaginationItem.vue"
import type { AlertsType } from "@/schemas"

const props = defineProps({
  page: {
    type: String,
    required: true
  },
  alerts: {
    type: Object as PropType<AlertsType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "refresh"): void
  (e: "update-page", value: number): void
}>()

const onUpdatePage = (page: number) => {
  emits("update-page", page)
}

const onDelete = () => {
  emits("refresh")
}

const hasAlerts = computed(() => {
  return props.alerts.results.length > 0
})
</script>

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
