<template>
  <Configs></Configs>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core";
import { defineComponent } from "vue";

import Configs from "@/components/config/ConfigsWrapper.vue";

export default defineComponent({
  name: "ConfigView",
  components: {
    Configs,
  },
  setup() {
    useTitle("Config - Mihari");
  },
});
</script>
