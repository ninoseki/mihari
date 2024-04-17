<script setup lang="ts">
import axios, { AxiosError } from "axios"
import { computed, type PropType } from "vue"

import { generateDeleteAlertTask } from "@/api-helper"
import type { AlertType } from "@/schemas"

const props = defineProps({
  alert: {
    type: Object as PropType<AlertType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "delete"): void
  (e: "set-error", value: AxiosError): void
}>()

const href = computed(() => {
  return `/api/alerts/${props.alert.id}`
})

const deleteAlertTask = generateDeleteAlertTask()

const deleteAlert = async () => {
  const confirmed = window.confirm(`Are you sure you want to delete ${props.alert.id}?`)

  if (confirmed) {
    try {
      await deleteAlertTask.perform(props.alert.id)
      emits("delete")
    } catch (err) {
      if (axios.isAxiosError(err)) {
        emits("set-error", err)
      }
    }
  }
}
</script>

<template>
  <span class="buttons is-pulled-right">
    <a class="button is-link is-light is-small" :href="href" target="_blank">
      <span>JSON</span>
      <span class="icon is-small">
        <font-awesome-icon icon="barcode"></font-awesome-icon>
      </span>
    </a>
    <button class="button is-light is-small" @click="deleteAlert">
      <span>Delete</span>
      <span class="icon is-small">
        <font-awesome-icon icon="times"></font-awesome-icon>
      </span>
    </button>
  </span>
</template>
