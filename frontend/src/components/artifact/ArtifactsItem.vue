<script setup lang="ts">
import { computed, type PropType } from "vue"

import Artifact from "@/components/artifact/ArtifactItem.vue"
import Pagination from "@/components/PaginationItem.vue"
import type { ArtifactsType } from "@/schemas"

const props = defineProps({
  artifacts: {
    type: Object as PropType<ArtifactsType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "refresh"): void
  (e: "update-page", value: number): void
}>()

const hasArtifacts = computed(() => {
  return props.artifacts.results.length > 0
})

const onUpdatePage = (page: number) => {
  emits("update-page", page)
}

const onDelete = () => {
  emits("refresh")
}
</script>

<template>
  <div v-if="hasArtifacts">
    <Artifact
      :artifact="artifact"
      v-for="artifact in artifacts.results"
      :key="artifact.id"
      @delete="onDelete"
    />
    <Pagination
      :total="artifacts.total"
      :currentPage="artifacts.currentPage"
      :pageSize="artifacts.pageSize"
      @update-page="onUpdatePage"
    />
    <p class="help">
      ({{ artifacts.total }} results in total, {{ artifacts.results.length }} shown)
    </p>
  </div>
  <div v-else>
    <div class="notification is-warning is-light">There is no artifact to show</div>
  </div>
</template>
