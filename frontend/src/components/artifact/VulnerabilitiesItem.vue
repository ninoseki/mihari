<script setup lang="ts">
import { type PropType } from "vue"

import type { VulnerabilityType } from "@/schemas"

defineProps({
  vulnerabilities: {
    type: Array as PropType<VulnerabilityType[]>,
    required: true
  }
})

const getQuery = (name: string) => {
  return `vuln:"${name}"`
}
</script>

<template>
  <div class="tags are-medium">
    <router-link
      class="tag"
      v-for="vuln in vulnerabilities"
      :key="vuln.name"
      :to="{ name: 'Artifacts', query: { q: getQuery(vuln.name) } }"
      >{{ vuln.name }}</router-link
    >
  </div>
</template>
