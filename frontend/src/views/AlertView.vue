<script setup lang="ts">
import { useTitle } from "@vueuse/core"
import { onMounted, watch } from "vue"

import Alert from "@/components/alert/AlertDetailWrapper.vue"

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})

const updateTitle = () => {
  useTitle(`Alert:${props.id} - Mihari`)
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
  <Alert :id="parseInt(id)" />
</template>
