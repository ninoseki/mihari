<script setup lang="ts">
import { type PropType, toRef } from "vue"
import { useRouter } from "vue-router"

import { generateUpdateRuleTask } from "@/api-helper"
import ErrorMessage from "@/components/ErrorMessage.vue"
import InputForm from "@/components/rule/InputForm.vue"
import type { RuleType } from "@/schemas"

const props = defineProps({
  rule: {
    type: Object as PropType<RuleType>,
    required: true
  }
})

const router = useRouter()

const yaml = toRef(props.rule.yaml)

const updateRuleTask = generateUpdateRuleTask()

const updateYAML = (value: string) => {
  yaml.value = value
}

const edit = async () => {
  const rule = await updateRuleTask.perform({
    yaml: yaml.value
  })

  router.push({ name: "Rule", params: { id: rule.id } })
}
</script>

<template>
  <div class="block">
    <h2 class="is-size-2 block">Edit rule: {{ rule.id }}</h2>
    <InputForm v-model:yaml="yaml" @update-yaml="updateYAML" />
    <div class="field is-grouped is-grouped-centered">
      <p class="control">
        <a class="button is-primary" @click="edit">
          <span class="icon is-small">
            <font-awesome-icon icon="edit"></font-awesome-icon>
          </span>
          <span>Edit</span>
        </a>
      </p>
    </div>
  </div>
  <div class="block" v-if="updateRuleTask.last?.error">
    <hr />
    <ErrorMessage :error="updateRuleTask.last?.error" />
  </div>
</template>
