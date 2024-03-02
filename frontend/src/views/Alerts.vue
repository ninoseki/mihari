<template>
  <OverviewCards></OverviewCards>
  <hr />
  <Alerts />
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core"
import { defineComponent } from "vue"

import Alerts from "@/components/alert/AlertsWrapper.vue"
import OverviewCards from "@/components/OverviewCards.vue"

export default defineComponent({
  name: "AlertsView",
  components: {
    Alerts,
    OverviewCards
  },
  setup() {
    useTitle("Alerts - Mihari")
  }
})
</script>
