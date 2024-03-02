<template>
  <a :href="link.href(data)" class="tag is-white" target="_blank">
    <img :src="link.favicon()" alt="favicon" />
    <span>{{ link.name }}</span>
  </a>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { LinkType } from "@/schemas"

export default defineComponent({
  name: "LinkItem",
  props: {
    data: {
      type: String,
      required: true
    },
    link: {
      type: Object as PropType<LinkType>,
      required: true
    }
  }
})
</script>

<style scoped>
.tag img {
  margin-right: 5px;
}
</style>
