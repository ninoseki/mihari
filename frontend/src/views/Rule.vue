<template>
  <Rule :id="ruleId"></Rule>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core";
import { defineComponent, onMounted, ref, watch } from "vue";

import Rule from "@/components/rule/RuleWrapper.vue";

export default defineComponent({
  name: "RuleView",
  components: {
    Rule,
  },
  props: {
    id: {
      type: String,
      required: true,
    },
  },
  setup(props) {
    const ruleId = ref<string>(props.id);

    const updateTitle = () => {
      useTitle(`Rule:${ruleId.value} - Mihari`);
    };

    onMounted(() => {
      updateTitle();
    });

    watch(
      () => props.id,
      () => {
        ruleId.value = props.id;
        updateTitle();
      }
    );

    return { ruleId };
  },
});
</script>
