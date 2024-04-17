<script setup lang="ts">
import { type PropType } from "vue"

import type { MessageType } from "@/schemas"

defineProps({
  message: {
    type: Object as PropType<MessageType>,
    required: true
  },
  disposable: {
    type: Boolean,
    default: false
  }
})

const emits = defineEmits<{
  (e: "dispose"): void
}>()

const dispose = () => {
  emits("dispose")
}
</script>

<template>
  <div class="notification is-info is-light">
    <button class="delete" v-if="disposable" @click="dispose"></button>
    <p>{{ message.message }}</p>
  </div>
</template>
