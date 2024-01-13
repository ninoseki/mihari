<template>
  <div class="tags are-medium">
    <span class="tag">
      {{ autonomousSystem.number }}
    </span>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { AutonomousSystem } from "@/types"

export default defineComponent({
  name: "AS",
  props: {
    autonomousSystem: {
      type: Object as PropType<AutonomousSystem>,
      required: true
    }
  }
})
</script>
