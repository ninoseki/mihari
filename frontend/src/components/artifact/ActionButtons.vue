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
      @click="toggleShowMetadata"
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
      <div class="modal-background" @click="toggleShowMetadata"></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Metadata</p>
          <button class="delete" aria-label="close" @click="toggleShowMetadata"></button>
        </header>
        <section class="modal-card-body">
          <VueJsonPretty :data="artifact.metadata" />
        </section>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import "vue-json-pretty/lib/styles.css"

import axios from "axios"
import truncate from "just-truncate"
import { computed, defineComponent, type PropType, ref } from "vue"
import VueJsonPretty from "vue-json-pretty"

import { generateDeleteArtifactTask, generateEnrichArtifactTask } from "@/api-helper"
import type { ArtifactType } from "@/schemas"

export default defineComponent({
  name: "ArtifactActionButtons",
  props: {
    artifact: {
      type: Object as PropType<ArtifactType>,
      required: true
    }
  },
  components: { VueJsonPretty },
  emits: ["delete", "set-error", "set-message"],
  setup(props, context) {
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
          await deleteArtifactTask.perform(props.artifact.id)
          context.emit("delete")
        } catch (err) {
          if (axios.isAxiosError(err)) {
            context.emit("set-error", err)
          }
        }
      }
    }

    const enrichArtifact = async () => {
      try {
        const message = await enrichArtifactTask.perform(props.artifact.id)
        context.emit("set-message", message)
      } catch (err) {
        if (axios.isAxiosError(err)) {
          context.emit("set-error", err)
        }
      }
    }

    const toggleShowMetadata = () => {
      showMetadata.value = !showMetadata.value
    }

    return {
      deleteArtifact,
      enrichArtifact,
      enrichArtifactTask,
      toggleShowMetadata,
      href,
      showMetadata,
      truncate
    }
  }
})
</script>

<style scoped>
.modal-card {
  width: 960px;
}
</style>
