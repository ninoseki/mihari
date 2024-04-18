<script setup lang="ts">
import { computed } from "vue"

import Link from "@/components/link/LinkItem.vue"
import { Links } from "@/links"
import type { LinkType } from "@/schemas"

const props = defineProps({
  data: {
    type: String,
    required: true
  },
  type: {
    type: String,
    required: true
  }
})

const selectedLinks = computed((): LinkType[] => {
  return Links.filter((link) => link.type === props.type)
})
</script>

<template>
  <div class="tags are-medium">
    <Link :data="data" :link="link" v-for="link in selectedLinks" :key="link.name" />
  </div>
</template>
