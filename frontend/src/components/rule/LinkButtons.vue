<template>
  <span class="buttons is-pulled-right">
    <a class="button is-small is-warning">
      <span>Alerts:</span>
      <span>{{ getAlertsTask.last?.value?.total }}</span>
    </a>
    <a class="button is-small is-success">
      <span>Artifacts:</span>
      <span>{{ getArtifactsTask.last?.value?.total }}</span>
    </a>
  </span>
</template>

<script lang="ts">
import { computed, defineComponent, onMounted, type PropType } from "vue"

import { generateGetAlertsTask, generateGetArtifactsTask } from "@/api-helper"
import type { Rule } from "@/types"

export default defineComponent({
  name: "RuleLinkButtons",
  props: {
    rule: {
      type: Object as PropType<Rule>,
      required: true
    }
  },
  setup(props) {
    const q = computed(() => {
      return `rule.id:"${props.rule.id}"`
    })

    const getAlertsTask = generateGetAlertsTask()
    const getArtifactsTask = generateGetArtifactsTask()

    onMounted(() => {
      getAlertsTask.perform({ q: q.value, page: 1, limit: 0 })
      getArtifactsTask.perform({ q: q.value, page: 1, limit: 0 })
    })

    return {
      getAlertsTask,
      getArtifactsTask
    }
  }
})
</script>
