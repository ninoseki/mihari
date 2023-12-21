<template>
  <div v-if="show">
    <div class="notification is-danger is-light">
      <button class="delete" v-if="disposable" @click="disposeError"></button>
      <p v-if="error.response.data?.message">{{ error.response.data.message }}</p>
      <p v-else>{{ error }}</p>
    </div>
    <article class="message" v-if="error.response.data?.details">
      <div class="message-body">
        <VueJsonPretty :data="error.response.data.details"></VueJsonPretty>
      </div>
    </article>
  </div>
</template>

<script lang="ts">
import "vue-json-pretty/lib/styles.css"

import { defineComponent, toRef } from "vue"
import VueJsonPretty from "vue-json-pretty"

export default defineComponent({
  name: "ErrorItem",
  props: {
    error: {
      type: Object,
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
  emits: ["dispose-error"],
  setup(props, context) {
    const show = toRef(props.disposable)
    const disposeError = () => {
      show.value = false
      context.emit("dispose-error")
    }

    return { show, disposeError }
  }
})
</script>
