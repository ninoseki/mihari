<script setup lang="ts">
import { type PropType } from "vue"

import type { CpeType } from "@/schemas"

defineProps({
  cpes: {
    type: Array as PropType<CpeType[]>,
    required: true
  }
})
const getQuery = (name: string) => {
  return `cpe:"${name}"`
}
</script>

<template>
  <div class="tags are-medium">
    <router-link
      class="tag"
      v-for="cpe in cpes"
      :key="cpe.name"
      :to="{ name: 'Artifacts', query: { q: getQuery(cpe.name) } }"
      >{{ cpe.name }}</router-link
    >
  </div>
</template>
