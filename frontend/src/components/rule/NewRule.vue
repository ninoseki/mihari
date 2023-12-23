<template>
  <div class="block">
    <h2 class="is-size-2 block">New rule</h2>
    <InputForm v-model:yaml="yaml" @update-yaml="updateYAML"></InputForm>
    <div class="field is-grouped is-grouped-centered">
      <p class="control">
        <a class="button is-primary" @click="create">
          <span class="icon is-small">
            <font-awesome-icon icon="plus"></font-awesome-icon>
          </span>
          <span>Create</span>
        </a>
      </p>
    </div>
  </div>
  <div class="block" v-if="createRuleTask.last?.error">
    <hr />
    <ErrorMessage :error="createRuleTask.last?.error"></ErrorMessage>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue"
import { useRouter } from "vue-router"

import { generateCreateRuleTask } from "@/api-helper"
import ErrorMessage from "@/components/ErrorMessage.vue"
import InputForm from "@/components/rule/InputForm.vue"
import { getRuleTemplate } from "@/rule"

export default defineComponent({
  name: "NewRule",
  components: {
    InputForm,
    ErrorMessage
  },
  setup() {
    const router = useRouter()
    const yaml = ref(getRuleTemplate())
    const createRuleTask = generateCreateRuleTask()

    const updateYAML = (value: string) => {
      yaml.value = value
    }

    const create = async () => {
      const rule = await createRuleTask.perform({ yaml: yaml.value })
      router.push({ name: "Rule", params: { id: rule.id } })
    }

    return { yaml, create, updateYAML, createRuleTask }
  }
})
</script>
