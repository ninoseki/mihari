<script setup lang="ts">
import { type PropType } from "vue"

import type { AutonomousSystemType } from "@/schemas"

defineProps({
  autonomousSystem: {
    type: Object as PropType<AutonomousSystemType>,
    required: true
  }
})

const getQuery = (number: number) => {
  return `asn:${number}`
}
</script>

<template>
  <div class="tags are-medium">
    <router-link
      class="tag"
      :to="{ name: 'Artifacts', query: { q: getQuery(autonomousSystem.number) } }"
      >{{ autonomousSystem.number }}</router-link
    >
  </div>
</template>
