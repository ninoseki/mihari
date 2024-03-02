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

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { CpeType } from "@/schemas"

export default defineComponent({
  name: "CPEsItem",
  props: {
    cpes: {
      type: Array as PropType<CpeType[]>,
      required: true
    }
  },
  setup() {
    const getQuery = (name: string) => {
      return `cpe:"${name}"`
    }
    return { getQuery }
  }
})
</script>
