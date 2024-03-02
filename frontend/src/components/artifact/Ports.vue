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

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { PortType } from "@/schemas"

export default defineComponent({
  name: "PortsItem",
  props: {
    ports: {
      type: Array as PropType<PortType[]>,
      required: true
    }
  },
  setup() {
    const getQuery = (port: number) => {
      return `port:${port}`
    }

    return { getQuery }
  }
})
</script>
