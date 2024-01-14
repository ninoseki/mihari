<template>
  <div class="field is-grouped is-grouped-multiline">
    <TagComponent
      v-for="tag in tags"
      :tag="tag"
      :key="tag.name"
      :deletable="deletable"
      :navigate-to="navigateTo"
    ></TagComponent>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import TagComponent from "@/components/tag/Tag.vue"
import type { NavigateTo, Tag } from "@/types"

export default defineComponent({
  name: "TagsItem",
  components: {
    TagComponent
  },
  props: {
    tags: {
      type: Array as PropType<Tag[]>,
      required: true
    },
    deletable: {
      type: Boolean,
      default: false
    },
    navigateTo: {
      type: String as PropType<NavigateTo>,
      required: true
    }
  },
  setup() {}
})
</script>
