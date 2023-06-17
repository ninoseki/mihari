<template>
  <div class="field is-grouped is-grouped-multiline">
    <TagComponent
      v-for="tag in tags"
      :tag="tag"
      :key="tag.name"
      @update-tag="updateTag"
    ></TagComponent>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";

import TagComponent from "@/components/tag/Tag.vue";
import { Tag } from "@/types";

export default defineComponent({
  name: "TagsItem",
  components: {
    TagComponent,
  },
  props: {
    tags: {
      type: Array as PropType<Tag[]>,
      required: true,
    },
  },
  setup(_, context) {
    const updateTag = (tag: string) => {
      context.emit("update-tag", tag);
    };

    return { updateTag };
  },
});
</script>
