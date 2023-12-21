<template>
  <div class="column">
    <h2 class="is-size-2 mb-4">Rule</h2>
    <ErrorMessage
      class="mt-3 mb-3"
      :error="error"
      v-if="error"
      :disposable="true"
      @dispose-error="disposeError"
    ></ErrorMessage>
    <p class="block is-clearfix">
      <ActionButtons :rule="rule" @refresh="refresh" @set-error="setError" />
    </p>
    <YAML :yaml="rule.yaml"></YAML>
  </div>
  <hr />
  <div class="column">
    <h2 class="is-size-2 mb-4">Alerts</h2>
    <Alerts :ruleId="rule.id"></Alerts>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType, ref } from "vue"

import Alerts from "@/components/alert/AlertsWithPagination.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import ActionButtons from "@/components/rule/ActionButtons.vue"
import YAML from "@/components/rule/YAML.vue"
import type { Rule } from "@/types"

export default defineComponent({
  name: "RuleDetailItem",
  props: {
    rule: {
      type: Object as PropType<Rule>,
      required: true
    }
  },
  components: {
    YAML,
    Alerts,
    ErrorMessage,
    ActionButtons
  },
  emits: ["refresh", "show-error"],
  setup(_, context) {
    const error = ref<unknown>(undefined)

    const refresh = () => {
      context.emit("refresh")
    }

    const setError = (newError: unknown) => {
      error.value = newError
    }

    const disposeError = () => {
      error.value = undefined
    }

    return { refresh, setError, error, disposeError }
  }
})
</script>
