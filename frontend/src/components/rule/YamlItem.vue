<script setup lang="ts">
import "@/ace-config"

import { VAceEditor } from "vue3-ace-editor"

defineProps({
  yaml: {
    type: String,
    required: true
  }
})
</script>

<template>
  <div class="block">
    <VAceEditor
      class="vue-ace-editor"
      :value="yaml"
      lang="yaml"
      theme="monokai"
      :options="{
        readOnly: true,
        fontSize: 16,
        maxLines: 10000,
        minLines: 6
      }"
    />
  </div>
</template>
