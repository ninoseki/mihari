<template>
  <div class="tags are-medium">
    <span class="tag" v-for="port in ports" :key="port.port">
      {{ port.port }}
    </span>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";

import { Port } from "@/types";

export default defineComponent({
  name: "PortsItem",
  props: {
    ports: {
      type: Array as PropType<Port[]>,
      required: true,
    },
  },
});
</script>
