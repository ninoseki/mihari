<template>
  <div class="tags are-medium">
    <span class="tag" v-for="cpe in cpes" :key="cpe.name">
      {{ cpe.name }}
    </span>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { CPE } from "@/types"

export default defineComponent({
  name: "CPEsItem",
  props: {
    cpes: {
      type: Array as PropType<CPE[]>,
      required: true
    }
  }
})
</script>
