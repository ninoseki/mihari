<template>
  <span class="buttons is-pulled-right">
    <a class="button is-link is-light is-small" :href="href" target="_blank">
      <span>JSON</span>
      <span class="icon is-small">
        <font-awesome-icon icon="barcode"></font-awesome-icon>
      </span>
    </a>
    <button
      class="button is-info is-light is-small"
      @click="toggleShowMetadata()"
      v-if="artifact.metadata"
    >
      <span>Metadata</span>
      <span class="icon is-small">
        <font-awesome-icon icon="info-circle"></font-awesome-icon>
      </span>
    </button>
    <button class="button is-primary is-light is-small" @click="enrichArtifact">
      <span>Enrich</span>
      <span class="icon is-small">
        <font-awesome-icon
          icon="spinner"
          spin
          v-if="enrichArtifactTask.isRunning"
        ></font-awesome-icon>
        <font-awesome-icon icon="lightbulb" v-else></font-awesome-icon>
      </span>
    </button>
    <button class="button is-light is-small" @click="deleteArtifact">
      <span>Delete</span>
      <span class="icon is-small">
        <font-awesome-icon icon="times"></font-awesome-icon>
      </span>
    </button>
  </span>
  <div v-if="artifact.metadata && showMetadata">
    <div class="modal is-active">
      <div class="modal-background" @click="toggleShowMetadata()"></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Metadata</p>
          <button class="delete" aria-label="close" @click="toggleShowMetadata()"></button>
        </header>
        <section class="modal-card-body">
          <VueJsonPretty :data="artifact.metadata" />
        </section>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import "vue-json-pretty/lib/styles.css"

import { useToggle } from "@vueuse/core"
import axios, { AxiosError } from "axios"
import { computed, type PropType, ref } from "vue"
import VueJsonPretty from "vue-json-pretty"

import { generateDeleteArtifactTask, generateEnrichArtifactTask } from "@/api-helper"
import type { ArtifactType, QueueMessageType } from "@/schemas"

const props = defineProps({
  artifact: {
    type: Object as PropType<ArtifactType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "delete"): void
  (e: "set-error", value: AxiosError): void
  (e: "set-message", value: QueueMessageType): void
}>()

const href = computed(() => {
  return `/api/artifacts/${props.artifact.id}`
})
const showMetadata = ref(false)

const deleteArtifactTask = generateDeleteArtifactTask()
const enrichArtifactTask = generateEnrichArtifactTask()

const deleteArtifact = async () => {
  const confirmed = window.confirm(`Are you sure you want to delete ${props.artifact.data}?`)

  if (confirmed) {
    try {
      console.log("baz?")
      await deleteArtifactTask.perform(props.artifact.id)
      console.log("baz")
      emits("delete")
    } catch (err) {
      if (axios.isAxiosError(err)) {
        emits("set-error", err)
      }
    }
  }
}

const enrichArtifact = async () => {
  try {
    const message = await enrichArtifactTask.perform(props.artifact.id)
    emits("set-message", message)
  } catch (err) {
    if (axios.isAxiosError(err)) {
      emits("set-error", err)
    }
  }
}

const toggleShowMetadata = useToggle(showMetadata)
</script>

<style scoped>
.modal-card {
  width: 960px;
}
</style>
