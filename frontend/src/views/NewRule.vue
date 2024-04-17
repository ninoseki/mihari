<script setup lang="ts">
import { useTitle } from "@vueuse/core"
import { onMounted } from "vue"

import NewRule from "@/components/rule/NewRule.vue"

const updateTitle = () => {
  useTitle(`New rule - Mihari`)
}

onMounted(() => {
  updateTitle()
})
</script>

<template>
  <NewRule />
</template>
