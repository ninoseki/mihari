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

<script lang="ts">
import axios from "axios"
import { computed, defineComponent, type PropType } from "vue"

import { generateDeleteAlertTask } from "@/api-helper"
import type { AlertType } from "@/schemas"

export default defineComponent({
  name: "AlertActionButtons",
  props: {
    alert: {
      type: Object as PropType<AlertType>,
      required: true
    }
  },
  emits: ["delete", "set-error"],
  setup(props, context) {
    const href = computed(() => {
      return `/api/alerts/${props.alert.id}`
    })

    const deleteAlertTask = generateDeleteAlertTask()

    const deleteAlert = async () => {
      const confirmed = window.confirm(`Are you sure you want to delete ${props.alert.id}?`)

      if (confirmed) {
        try {
          await deleteAlertTask.perform(props.alert.id)
          context.emit("delete")
        } catch (err) {
          if (axios.isAxiosError(err)) {
            context.emit("set-error", err)
          }
        }
      }
    }

    return { href, deleteAlert }
  }
})
</script>
