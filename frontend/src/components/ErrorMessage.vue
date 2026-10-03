<script setup lang="ts">
import "vue-json-pretty/lib/styles.css"
import { HTTPError } from "ky"
import { computed } from "vue"
import VueJsonPretty from "vue-json-pretty"

import type { ErrorMessageType } from "@/schemas"

const props = defineProps({
  error: {
    type: HTTPError,
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

const data = computed<ErrorMessageType | undefined>(() => {
  return props.error.data as ErrorMessageType | undefined
})

const dispose = () => {
  emits("dispose")
}
</script>

<template>
  <div class="notification is-danger is-light">
    <button class="delete" v-if="disposable" @click="dispose"></button>
    <p v-if="data">{{ data.message }}</p>
    <p v-else>{{ error }}</p>
  </div>
  <article class="message" v-if="data?.detail">
    <div class="message-body">
      <VueJsonPretty :data="data.detail" />
    </div>
  </article>
</template>
