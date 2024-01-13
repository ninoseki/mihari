<template>
  <div class="tags are-medium">
    <span class="tag" v-for="vuln in vulnerabilities" :key="vuln.name">
      {{ vuln.name }}
    </span>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { Vulnerability } from "@/types"

export default defineComponent({
  name: "VulnerabilitiesItem",
  props: {
    vulnerabilities: {
      type: Array as PropType<Vulnerability[]>,
      required: true
    }
  }
})
</script>
