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

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import Tag from "@/components/tag/Tag.vue"
import type { NavigateToType, TagType } from "@/schemas"

export default defineComponent({
  name: "TagsItem",
  components: {
    Tag
  },
  props: {
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
  },
  setup() {}
})
</script>
