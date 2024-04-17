<script setup lang="ts">
import { type PropType } from "vue"

import Tag from "@/components/tag/TagItem.vue"
import type { NavigateToType, TagType } from "@/schemas"

defineProps({
  tags: {
    type: Array as PropType<TagType[]>,
    required: true
  },
  deletable: {
    type: Boolean,
    default: false
  },
  navigateTo: {
    type: String as PropType<NavigateToType>,
    required: true
  }
})
</script>

<template>
  <div class="field is-grouped is-grouped-multiline">
    <Tag
      v-for="tag in tags"
      :tag="tag"
      :key="tag.name"
      :deletable="deletable"
      :navigate-to="navigateTo"
    />
  </div>
</template>
