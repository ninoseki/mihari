<template>
  <div class="tags are-medium">
    <span class="tag" v-for="port in ports" :key="port.number">
      {{ port.number }}
    </span>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { Port } from "@/types"

export default defineComponent({
  name: "PortsItem",
  props: {
    ports: {
      type: Array as PropType<Port[]>,
      required: true
    }
  }
})
</script>
