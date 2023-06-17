<template>
  <div class="tags are-medium">
    <span class="tag" v-for="cpe in cpes" :key="cpe.cpe">
      {{ cpe.cpe }}
    </span>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";

import { CPE } from "@/types";

export default defineComponent({
  name: "CPEsItem",
  props: {
    cpes: {
      type: Array as PropType<CPE[]>,
      required: true,
    },
  },
});
</script>
