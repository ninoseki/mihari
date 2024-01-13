<template>
  <div class="tags are-medium">
    <router-link
      class="tag"
      v-for="reverseDnsName in reverseDnsNames"
      :key="reverseDnsName.name"
      :to="{ name: 'Artifacts', query: { q: getQuery(reverseDnsName.name) } }"
      >{{ reverseDnsName.name }}</router-link
    >
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { ReverseDnsName } from "@/types"

export default defineComponent({
  name: "ReverseDnsNames",
  props: {
    reverseDnsNames: {
      type: Array as PropType<ReverseDnsName[]>,
      required: true
    }
  },
  setup() {
    const getQuery = (name: string) => {
      return `reverse_dns_name:"${name}"`
    }

    return { getQuery }
  }
})
</script>
