<template>
  <div class="notification is-info is-light">
    <button class="delete" v-if="disposable" @click="dispose"></button>
    <p>{{ message.message }}</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { MessageType } from "@/schemas"

export default defineComponent({
  name: "MessageItem",
  props: {
    message: {
      type: Object as PropType<MessageType>,
      required: true
    },
    disposable: {
      type: Boolean,
      default: false
    }
  },
  emits: ["dispose"],
  setup(_, context) {
    const dispose = () => {
      context.emit("dispose")
    }
    return { dispose }
  }
})
</script>
