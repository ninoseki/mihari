<template>
  <div class="tags are-medium">
    <router-link
      class="tag"
      :to="{ name: 'Artifacts', query: { q: getQuery(autonomousSystem.number) } }"
      >{{ autonomousSystem.number }}</router-link
    >
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { AutonomousSystem } from "@/types"

export default defineComponent({
  name: "AS",
  props: {
    autonomousSystem: {
      type: Object as PropType<AutonomousSystem>,
      required: true
    }
  },
  setup() {
    const getQuery = (number: number) => {
      return `asn:${number}`
    }
    return { getQuery }
  }
})
</script>
