<script setup lang="ts">
import "@/ace-config"
import { toRef, watchEffect } from "vue"
import { VAceEditor } from "vue3-ace-editor"

const props = defineProps({
  yaml: {
    type: String,
    required: true
  }
})

const emits = defineEmits<{
  (e: "update-yaml", value: string): void
}>()

const yamlInput = toRef(props, "yaml")

watchEffect(() => {
  emits("update-yaml", yamlInput.value)
})
</script>

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
    />
  </div>
</template>
