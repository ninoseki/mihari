<template>
  <Rules></Rules>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core";
import { defineComponent } from "vue";

import Rules from "@/components/rule/RulesWrapper.vue";

export default defineComponent({
  name: "RulesView",
  components: {
    Rules,
  },
  setup() {
    useTitle("Rules - Mihari");
  },
});
</script>
