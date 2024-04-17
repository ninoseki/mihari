<script setup lang="ts">
import { type PropType } from "vue"

import type { ReverseDnsNameType } from "@/schemas"

defineProps({
  reverseDnsNames: {
    type: Array as PropType<ReverseDnsNameType[]>,
    required: true
  }
})

const getQuery = (name: string) => {
  return `reverse_dns_name:"${name}"`
}
</script>

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
