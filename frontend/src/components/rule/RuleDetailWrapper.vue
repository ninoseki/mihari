<template>
  <Loading v-if="getRuleTask.isRunning"></Loading>
  <ErrorMessage v-if="getRuleTask.isError" :error="getRuleTask.last?.error"></ErrorMessage>
  <Rule
    :rule="getRuleTask.last.value"
    @refresh="onRefresh"
    @delete="onDelete"
    v-if="getRuleTask.last?.value"
  ></Rule>
</template>

<script lang="ts">
import { defineComponent, onMounted, watch } from "vue"
import { useRouter } from "vue-router"

import { generateGetRuleTask } from "@/api-helper"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"
import Rule from "@/components/rule/RuleDetail.vue"

export default defineComponent({
  name: "RuleDetailWrapper",
  components: {
    Rule,
    Loading,
    ErrorMessage
  },
  props: {
    id: {
      type: String,
      required: true
    }
  },
  setup(props) {
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

    return {
      getRuleTask,
      onRefresh,
      onDelete
    }
  }
})
</script>
