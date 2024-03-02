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

<script lang="ts">
import "@/ace-config"

import { defineComponent } from "vue"
import { VAceEditor } from "vue3-ace-editor"

export default defineComponent({
  name: "YAML",
  components: {
    VAceEditor
  },
  props: {
    yaml: {
      type: String,
      required: true
    }
  },
  setup() {}
})
</script>
