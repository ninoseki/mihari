<script setup lang="ts">
import { onMounted } from "vue"

import { generateGetConfigsTask } from "@/api-helper"
import Configs from "@/components/config/ConfigsItem.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/LoadingItem.vue"

const getConfigsTask = generateGetConfigsTask()

onMounted(async () => {
  await getConfigsTask.perform()
})
</script>

<template>
  <Loading v-if="getConfigsTask.isRunning" />
  <ErrorMessage v-if="getConfigsTask.isError" :error="getConfigsTask.last?.error" />
  <Configs :configs="getConfigsTask.last.value" v-if="getConfigsTask.last?.value" />
</template>
