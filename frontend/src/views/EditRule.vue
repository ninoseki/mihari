<script setup lang="ts">
import { useTitle } from "@vueuse/core"
import { onMounted, watch } from "vue"

import EditRule from "@/components/rule/EditRuleWrapper.vue"

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})

const updateTitle = () => {
  useTitle(`Edit rule:${props.id} - Mihari`)
}

onMounted(() => {
  updateTitle()
})

watch(
  () => props.id,
  () => {
    updateTitle()
  }
)
</script>

<template>
  <EditRule :id="id" />
</template>
