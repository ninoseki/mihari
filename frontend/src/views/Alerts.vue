<template>
  <Alerts></Alerts>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core";
import { defineComponent } from "vue";

import Alerts from "@/components/alert/AlertsWrapper.vue";

export default defineComponent({
  name: "AlertsView",
  components: {
    Alerts,
  },
  setup() {
    useTitle("Alerts - Mihari");
  },
});
</script>
