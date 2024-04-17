<script setup lang="ts">
import { useTitle } from "@vueuse/core"
import { onMounted, watch } from "vue"

import Rule from "@/components/rule/RuleDetailWrapper.vue"

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})

const updateTitle = () => {
  useTitle(`Rule:${props.id} - Mihari`)
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
  <Rule :id="id" />
</template>
