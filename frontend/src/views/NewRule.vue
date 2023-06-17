<template>
  <NewRule></NewRule>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core";
import { defineComponent, onMounted } from "vue";

import NewRule from "@/components/rule/NewRule.vue";

export default defineComponent({
  name: "NewRuleView",
  components: {
    NewRule,
  },
  setup() {
    const updateTitle = () => {
      useTitle(`New rule - Mihari`);
    };

    onMounted(() => {
      updateTitle();
    });
  },
});
</script>
