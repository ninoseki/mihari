<script setup lang="ts">
import { onMounted, watch } from "vue"

import { generateGetRuleTask } from "@/api-helper"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/LoadingItem.vue"
import EditRule from "@/components/rule/EditRule.vue"

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})

const getRuleTask = generateGetRuleTask()

const getRule = async () => {
  await getRuleTask.perform(props.id)
}

onMounted(async () => {
  await getRule()
})

watch(props, async () => {
  await getRule()
})
</script>

<template>
  <Loading v-if="getRuleTask.isRunning" />
  <ErrorMessage v-if="getRuleTask.isError" :error="getRuleTask.last?.error" />
  <EditRule :rule="getRuleTask.last.value" v-if="getRuleTask.last?.value" />
</template>
