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

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { VulnerabilityType } from "@/schemas"

export default defineComponent({
  name: "VulnerabilitiesItem",
  props: {
    vulnerabilities: {
      type: Array as PropType<VulnerabilityType[]>,
      required: true
    }
  },
  setup() {
    const getQuery = (name: string) => {
      return `vuln:"${name}"`
    }
    return { getQuery }
  }
})
</script>
