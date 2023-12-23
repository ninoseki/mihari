<template>
  <div class="block">
    <h2 class="is-size-2 block">{{ rule.id }}</h2>
    <ErrorMessage
      class="mt-3 mb-3"
      :error="error"
      v-if="error"
      :disposable="true"
      @dispose="onDisposeError"
    ></ErrorMessage>
    <p class="block is-clearfix">
      <ActionButtons :rule="rule" @refresh="onRefresh" @delete="onDelete" @set-error="onSetError" />
    </p>
    <YAML :yaml="rule.yaml"></YAML>
  </div>
  <hr />
  <div class="block">
    <h2 class="is-size-2 block">Alerts</h2>
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
  emits: ["refresh", "delete"],
  setup(_, context) {
    const error = ref<unknown>(undefined)

    const onRefresh = () => {
      context.emit("refresh")
    }

    const onDelete = () => {
      context.emit("delete")
    }

    const onSetError = (newError: unknown) => {
      error.value = newError
    }

    const onDisposeError = () => {
      error.value = undefined
    }

    return { onRefresh, onSetError, error, onDisposeError, onDelete }
  }
})
</script>
