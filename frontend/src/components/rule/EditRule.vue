<template>
  <div class="column">
    <h2 class="is-size-2 mb-4">Edit rule: {{ rule.id }}</h2>

    <InputForm v-model:yaml="yaml" @update-yaml="updateYAML"></InputForm>

    <div class="field is-grouped is-grouped-centered">
      <p class="control">
        <a class="button is-primary" @click="edit">
          <span class="icon is-small">
            <i class="fas fa-edit"></i>
          </span>
          <span>Edit</span>
        </a>
      </p>
    </div>

    <div v-if="updateRuleTask.last?.error">
      <hr />
      <ErrorMessage :error="updateRuleTask.last?.error"></ErrorMessage>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType, ref } from "vue";
import { useRouter } from "vue-router";

import { generateUpdateRuleTask } from "@/api-helper";
import ErrorMessage from "@/components/ErrorMessage.vue";
import InputForm from "@/components/rule/InputForm.vue";
import { Rule } from "@/types";

export default defineComponent({
  name: "EditRule",
  components: {
    InputForm,
    ErrorMessage,
  },
  props: {
    rule: {
      type: Object as PropType<Rule>,
      required: true,
    },
  },
  setup(props) {
    const router = useRouter();

    const yaml = ref(props.rule.yaml);

    const updateRuleTask = generateUpdateRuleTask();

    const updateYAML = (value: string) => {
      yaml.value = value;
    };

    const edit = async () => {
      const rule = await updateRuleTask.perform({
        id: props.rule.id,
        yaml: yaml.value,
      });

      router.push({ name: "Rule", params: { id: rule.id } });
    };

    return {
      edit,
      yaml,
      updateYAML,
      updateRuleTask,
    };
  },
});
</script>
