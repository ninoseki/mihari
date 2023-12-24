<template>
  <Loading v-if="getArtifactTask.isRunning"></Loading>
  <ErrorMessage v-if="getArtifactTask.isError" :error="getArtifactTask.last?.error"></ErrorMessage>
  <ArtifactComponent
    :artifact="getArtifactTask.last.value"
    @refresh="onRefresh"
    @delete="onDelete"
    v-if="getArtifactTask.last?.value"
  ></ArtifactComponent>
</template>

<script lang="ts">
import { defineComponent, onMounted, watch } from "vue"
import { useRouter } from "vue-router"

import { generateGetArtifactTask } from "@/api-helper"
import ArtifactComponent from "@/components/artifact/ArtifactDetail.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"

export default defineComponent({
  name: "ArtifactDetailWrapper",
  components: {
    ArtifactComponent,
    Loading,
    ErrorMessage
  },
  props: {
    id: {
      type: Number,
      required: true
    }
  },
  setup(props) {
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

    return {
      getArtifactTask,
      onRefresh,
      onDelete
    }
  }
})
</script>
