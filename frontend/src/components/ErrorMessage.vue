<template>
  <div class="notification is-danger is-light">
    <button class="delete" v-if="disposable" @click="dispose"></button>
    <p v-if="data">{{ data.message }}</p>
    <p v-else>{{ error }}</p>
  </div>
  <article class="message" v-if="data?.detail">
    <div class="message-body">
      <VueJsonPretty :data="data.detail"></VueJsonPretty>
    </div>
  </article>
</template>

<script lang="ts">
import "vue-json-pretty/lib/styles.css"

import { AxiosError } from "axios"
import { computed, defineComponent } from "vue"
import VueJsonPretty from "vue-json-pretty"

import type { ErrorMessage } from "@/types"

export default defineComponent({
  name: "ErrorItem",
  props: {
    error: {
      type: AxiosError,
      required: true
    },
    disposable: {
      type: Boolean,
      default: false
    }
  },
  components: {
    VueJsonPretty
  },
  emits: ["dispose"],
  setup(props, context) {
    const data = computed<ErrorMessage | undefined>(() => {
      if (props.error.response) {
        return props.error.response?.data as ErrorMessage
      }
      return undefined
    })

    const dispose = () => {
      context.emit("dispose")
    }

    return { dispose, data }
  }
})
</script>
