<script setup lang="ts">
import { type PropType } from "vue"

import type { PortType } from "@/schemas"

defineProps({
  ports: {
    type: Array as PropType<PortType[]>,
    required: true
  }
})

const getQuery = (port: number) => {
  return `port:${port}`
}
</script>

<template>
  <div class="tags are-medium">
    <router-link
      class="tag"
      v-for="port in ports"
      :key="port.number"
      :to="{ name: 'Artifacts', query: { q: getQuery(port.number) } }"
      >{{ port.number }}</router-link
    >
  </div>
</template>
