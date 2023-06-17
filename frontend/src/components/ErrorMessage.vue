<template>
  <div class="notification is-danger is-light">
    <p v-if="error.response.data?.message">{{ error.response.data.message }}</p>
    <p v-else>{{ error }}</p>
  </div>

  <article class="message" v-if="error.response.data?.details">
    <div class="message-body">
      <VueJsonPretty :data="error.response.data.details"></VueJsonPretty>
    </div>
  </article>
</template>

<script lang="ts">
import "vue-json-pretty/lib/styles.css";

import { defineComponent } from "vue";
import VueJsonPretty from "vue-json-pretty";

export default defineComponent({
  name: "ErrorItem",
  props: {
    error: {
      type: Object,
      required: true,
    },
  },
  components: {
    VueJsonPretty,
  },
});
</script>
