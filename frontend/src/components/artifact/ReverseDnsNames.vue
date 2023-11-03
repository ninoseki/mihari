<template>
  <div class="tags are-medium">
    <span class="tag" v-for="reverseDnsName in reverseDnsNames" :key="reverseDnsName.name">
      {{ reverseDnsName.name }}
    </span>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { ReverseDnsName } from "@/types"

export default defineComponent({
  name: "ReverseDnsNames",
  props: {
    reverseDnsNames: {
      type: Array as PropType<ReverseDnsName[]>,
      required: true
    }
  }
})
</script>
