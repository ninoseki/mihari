<script setup lang="ts">
import { useDark } from "@vueuse/core"
import { type PropType } from "vue"

import type { LinkType } from "@/schemas"

defineProps({
  data: {
    type: String,
    required: true
  },
  link: {
    type: Object as PropType<LinkType>,
    required: true
  }
})

const isDark = useDark()
</script>
<template>
  <a :href="link.href(data)" :class="['tag', isDark ? '' : 'is-white']" target="_blank">
    <img :src="link.favicon()" alt="favicon" />
    <span>{{ link.name }}</span>
  </a>
</template>

<style scoped>
.tag img {
  margin-right: 5px;
}
</style>
