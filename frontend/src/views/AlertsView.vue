<script setup lang="ts">
import { useTitle } from "@vueuse/core"

import Alerts from "@/components/alert/AlertsWrapper.vue"
import OverviewCards from "@/components/OverviewCards.vue"

useTitle("Alerts - Mihari")
</script>

<template>
  <OverviewCards />
  <hr />
  <Alerts />
</template>
