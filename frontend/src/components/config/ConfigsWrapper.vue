<template>
  <Loading v-if="getConfigsTask.isRunning" />
  <ErrorMessage v-if="getConfigsTask.isError" :error="getConfigsTask.last?.error" />
  <Configs :configs="getConfigsTask.last.value" v-if="getConfigsTask.last?.value" />
</template>

<script lang="ts">
import { defineComponent, onMounted } from "vue"

import { generateGetConfigsTask } from "@/api-helper"
import Configs from "@/components/config/Configs.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"

export default defineComponent({
  name: "ConfigsWrapper",
  components: {
    Configs,
    Loading,
    ErrorMessage
  },
  setup() {
    const getConfigsTask = generateGetConfigsTask()

    onMounted(async () => {
      await getConfigsTask.perform()
    })

    return { getConfigsTask }
  }
})
</script>
