<template>
  <div class="tags are-medium">
    <LinkComponent
      :data="data"
      :link="link"
      v-for="link in selectedLinks"
      :key="link.name"
    />
  </div>
</template>

<script lang="ts">
import { computed, defineComponent } from "vue";

import LinkComponent from "@/components/link/Link.vue";
import { Links } from "@/links";
import { Link } from "@/types";

export default defineComponent({
  name: "LinksItem",
  components: {
    LinkComponent,
  },
  props: {
    data: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      required: true,
    },
  },
  setup(props) {
    const links = Links;
    const selectedLinks = computed((): Link[] => {
      if (props.type === undefined) {
        return links;
      }

      return links.filter((link) => link.type === props.type);
    });

    return { selectedLinks };
  },
});
</script>
