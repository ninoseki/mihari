<template>
  <EditRule :id="id"></EditRule>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core";
import { defineComponent, onMounted, ref, watch } from "vue";

import EditRule from "@/components/rule/EditRuleWrapper.vue";

export default defineComponent({
  name: "EditRuleView",
  components: {
    EditRule,
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
      useTitle(`Edit rule:${ruleId.value} - Mihari`);
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
