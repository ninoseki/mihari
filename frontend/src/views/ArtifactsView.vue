<script setup lang="ts">
import { useTitle } from "@vueuse/core"
import { onMounted } from "vue"

import Artifacts from "@/components/artifact/ArtifactsWrapper.vue"

const updateTitle = () => {
  useTitle(`Artifacts - Mihari`)
}

onMounted(() => {
  updateTitle()
})
</script>

<template>
  <Artifacts />
</template>
