<script setup lang="ts">
import { onMounted, watch } from "vue"
import { useRouter } from "vue-router"

import { generateGetRuleTask } from "@/api-helper"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/LoadingItem.vue"
import Rule from "@/components/rule/RuleDetail.vue"

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})

const getRuleTask = generateGetRuleTask()
const router = useRouter()

const getRule = async () => {
  await getRuleTask.perform(props.id)
}

const onRefresh = async () => {
  await getRule()
}

const onDelete = () => {
  router.push("/")
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
  <Rule
    :rule="getRuleTask.last.value"
    @refresh="onRefresh"
    @delete="onDelete"
    v-if="getRuleTask.last?.value"
  />
</template>
