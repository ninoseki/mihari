<template>
  <a :href="link.href(data)" class="tag is-white" target="_blank">
    <img :src="link.favicon()" alt="favicon" />
    <span>{{ link.name }}</span>
  </a>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";

import { Link } from "@/types";

export default defineComponent({
  name: "LinkItem",
  props: {
    data: {
      type: String,
      required: true,
    },
    link: {
      type: Object as PropType<Link>,
      required: true,
    },
  },
});
</script>

<style scoped>
.tag img {
  margin-right: 5px;
}
</style>
