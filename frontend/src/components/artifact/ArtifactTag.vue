<script setup lang="ts">
import truncate from "just-truncate"
import { type PropType, ref } from "vue"

import { generateDeleteArtifactTask } from "@/api-helper"
import type { ArtifactType } from "@/schemas"

const props = defineProps({
  artifact: {
    type: Object as PropType<ArtifactType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "delete"): void
}>()

const isDeleted = ref(false)
const isDeleteButtonEnabled = ref(false)

const deleteArtifactTask = generateDeleteArtifactTask()

const deleteArtifact = async () => {
  const confirmed = window.confirm(`Are you sure you want to delete ${props.artifact.data}?`)

  if (confirmed) {
    await deleteArtifactTask.perform(props.artifact.id)
    isDeleted.value = true
    emits("delete")
  }
}

const showDeleteButton = () => {
  isDeleteButtonEnabled.value = true
}

const hideDeleteButton = () => {
  isDeleteButtonEnabled.value = false
}
</script>

<template>
  <div class="control" v-if="!isDeleted">
    <div
      class="tags has-addons are-medium"
      v-on:mouseover="showDeleteButton"
      v-on:mouseleave="hideDeleteButton"
    >
      <router-link
        class="tag is-link is-light"
        :to="{ name: 'Artifact', params: { id: artifact.id } }"
        >{{ truncate(artifact.data, 32) }}</router-link
      >
      <span class="tag is-delete" v-if="isDeleteButtonEnabled" @click="deleteArtifact"></span>
    </div>
  </div>
</template>
