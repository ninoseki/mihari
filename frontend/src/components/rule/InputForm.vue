<template>
  <div class="block">
    <VAceEditor
      class="vue-ace-editor"
      v-model:value="yamlInput"
      lang="yaml"
      theme="monokai"
      :options="{
        fontSize: 16,
        minLines: 6,
        maxLines: 10000
      }"
    ></VAceEditor>
  </div>
</template>

<script lang="ts">
import "@/ace-config"

import { defineComponent, toRef, watchEffect } from "vue"
import { VAceEditor } from "vue3-ace-editor"

export default defineComponent({
  name: "RuleInputForm",
  components: {
    VAceEditor
  },
  props: {
    yaml: {
      type: String,
      required: true
    }
  },
  emits: ["update-yaml"],
  setup(props, context) {
    const yamlInput = toRef(props, "yaml")

    watchEffect(() => {
      context.emit("update-yaml", yamlInput.value)
    })

    return { yamlInput }
  }
})
</script>
