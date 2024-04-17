<script setup lang="ts">
import { useTitle } from "@vueuse/core"
import { onMounted, watch } from "vue"

import Artifact from "@/components/artifact/ArtifactDetailWrapper.vue"

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})
const updateTitle = () => {
  useTitle(`Artifact:${props.id} - Mihari`)
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
  <Artifact :id="parseInt(id)" />
</template>
