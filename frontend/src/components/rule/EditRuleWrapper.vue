<template>
  <Loading v-if="getRuleTask.isRunning"></Loading>

  <ErrorMessage
    v-if="getRuleTask.isError"
    :error="getRuleTask.last?.error"
  ></ErrorMessage>

  <EditRule
    :rule="getRuleTask.last.value"
    v-if="getRuleTask.last?.value"
  ></EditRule>
</template>

<script lang="ts">
import { defineComponent, onMounted, watch } from "vue";

import { generateGetRuleTask } from "@/api-helper";
import ErrorMessage from "@/components/ErrorMessage.vue";
import Loading from "@/components/Loading.vue";
import EditRule from "@/components/rule/EditRule.vue";

export default defineComponent({
  name: "EditRuleWrapper",
  components: {
    EditRule,
    Loading,
    ErrorMessage,
  },
  props: {
    id: {
      type: String,
      required: true,
    },
  },
  setup(props) {
    const getRuleTask = generateGetRuleTask();

    const getRule = async () => {
      await getRuleTask.perform(props.id);
    };

    onMounted(async () => {
      await getRule();
    });

    watch(props, async () => {
      await getRule();
    });

    return {
      getRuleTask,
    };
  },
});
</script>
