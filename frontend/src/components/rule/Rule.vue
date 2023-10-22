<template>
  <div class="column">
    <div v-if="runRuleTask.isRunning">
      <Loading></Loading>
      <hr />
    </div>
    <div v-if="runRuleTask.last?.error">
      <ErrorMessage :error="runRuleTask.last.error"></ErrorMessage>
      <hr />
    </div>
    <h2 class="is-size-2 mb-4">Rule</h2>
    <p class="block is-clearfix">
      <span class="buttons is-pulled-right">
        <button class="button is-primary is-light is-small" @click="runRule">
          <span>Run</span>
          <span class="icon is-small">
            <font-awesome-icon icon="arrow-right"></font-awesome-icon>
          </span>
        </button>
        <router-link
          class="button is-info is-light is-small"
          :to="{ name: 'EditRule', params: { id: rule.id } }"
        >
          <span>Edit</span>
          <span class="icon is-small">
            <font-awesome-icon icon="edit"></font-awesome-icon>
          </span>
        </router-link>
        <button class="button is-light is-small" @click="deleteRule">
          <span>Delete</span>
          <span class="icon is-small">
            <font-awesome-icon icon="times"></font-awesome-icon>
          </span>
        </button>
      </span>
    </p>
    <YAML :yaml="rule.yaml"></YAML>
  </div>
  <hr />
  <div class="column">
    <h2 class="is-size-2 mb-4">Related alerts</h2>

    <Alerts :ruleId="rule.id"></Alerts>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"
import { useRouter } from "vue-router"

import { generateDeleteRuleTask, generateRunRuleTask } from "@/api-helper"
import Alerts from "@/components/alert/AlertsWithPagination.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"
import YAML from "@/components/rule/YAML.vue"
import type { Rule } from "@/types"

export default defineComponent({
  name: "RuleItem",
  props: {
    rule: {
      type: Object as PropType<Rule>,
      required: true
    }
  },
  components: {
    YAML,
    Alerts,
    Loading,
    ErrorMessage
  },
  emits: ["refresh"],
  setup(props, context) {
    const router = useRouter()

    const deleteRuleTask = generateDeleteRuleTask()
    const runRuleTask = generateRunRuleTask()

    const deleteRule = async () => {
      const result = window.confirm(`Are you sure you want to delete ${props.rule.id}?`)

      if (result) {
        await deleteRuleTask.perform(props.rule.id)
        router.push("/")
      }
    }

    const runRule = async () => {
      await runRuleTask.perform(props.rule.id)
      context.emit("refresh")
    }

    return {
      deleteRule,
      runRule,
      runRuleTask
    }
  }
})
</script>
