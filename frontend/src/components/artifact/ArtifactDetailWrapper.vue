<script setup lang="ts">
import { onMounted, watch } from "vue"
import { useRouter } from "vue-router"

import { generateGetArtifactTask } from "@/api-helper"
import Artifact from "@/components/artifact/ArtifactDetail.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/LoadingItem.vue"

const props = defineProps({
  id: {
    type: Number,
    required: true
  }
})

const getArtifactTask = generateGetArtifactTask()
const router = useRouter()

const getArtifact = async () => {
  await getArtifactTask.perform(props.id)
}

const onRefresh = async () => {
  await getArtifact()
}

const onDelete = async () => {
  router.push("/")
}

onMounted(async () => {
  await getArtifact()
})

watch(props, async () => {
  await getArtifact()
})
</script>

<template>
  <Loading v-if="getArtifactTask.isRunning" />
  <ErrorMessage v-if="getArtifactTask.isError" :error="getArtifactTask.last?.error" />
  <Artifact
    :artifact="getArtifactTask.last.value"
    @refresh="onRefresh"
    @delete="onDelete"
    v-if="getArtifactTask.last?.value"
  />
</template>
