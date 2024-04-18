<script setup lang="ts">
import { onMounted } from "vue"
import { useRouter } from "vue-router"

import { generateGetAlertTask } from "@/api-helper"
import Alert from "@/components/alert/AlertDetail.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/LoadingItem.vue"

const props = defineProps({
  id: {
    type: Number,
    required: true
  }
})
const router = useRouter()
const getAlertTask = generateGetAlertTask()

const onDelete = () => {
  router.push("/")
}

onMounted(async () => {
  await getAlertTask.perform(props.id)
})
</script>

<template>
  <Loading v-if="getAlertTask.isRunning" />
  <ErrorMessage v-if="getAlertTask.isError" :error="getAlertTask.last?.error" />
  <Alert :alert="getAlertTask.last.value" @delete="onDelete" v-if="getAlertTask.last?.value" />
</template>
