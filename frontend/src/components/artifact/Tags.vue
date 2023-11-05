<template>
  <div class="tags are-medium">
    <router-link
      class="tag is-info is-light"
      v-for="tag in tags"
      :key="tag.id"
      :to="{
        name: 'Alerts',
        query: { tag: tag.name }
      }"
    >
      {{ tag.name }}
    </router-link>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { Tag } from "@/types"

export default defineComponent({
  name: "TagsItem",
  props: {
    tags: {
      type: Array as PropType<Tag[]>,
      required: true
    }
  }
})
</script>
