<template>
  <div class="tags are-medium">
    <LinkComponent :data="data" :link="link" v-for="link in selectedLinks" :key="link.name" />
  </div>
</template>

<script lang="ts">
import { computed, defineComponent } from "vue"

import LinkComponent from "@/components/link/Link.vue"
import { Links } from "@/links"
import type { LinkType } from "@/schemas"

export default defineComponent({
  name: "LinksItem",
  components: {
    LinkComponent
  },
  props: {
    data: {
      type: String,
      required: true
    },
    type: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const selectedLinks = computed((): LinkType[] => {
      return Links.filter((link) => link.type === props.type)
    })

    return { selectedLinks }
  }
})
</script>
