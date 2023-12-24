<template>
  <div v-if="hasArtifacts">
    <Artifact
      :artifact="artifact"
      v-for="artifact in artifacts.results"
      :key="artifact.id"
      @delete="onDelete"
    ></Artifact>
    <Pagination
      :total="artifacts.total"
      :currentPage="artifacts.currentPage"
      :pageSize="artifacts.pageSize"
      @update-page="onUpdatePage"
    ></Pagination>
    <p class="help">
      ({{ artifacts.total }} results in total, {{ artifacts.results.length }} shown)
    </p>
  </div>
  <div v-else>
    <div class="notification is-warning is-light">There is no artifact to show</div>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent, type PropType } from "vue"

import Artifact from "@/components/artifact/Artifact.vue"
import Pagination from "@/components/Pagination.vue"
import type { Artifacts } from "@/types"

export default defineComponent({
  name: "ArtifactsItem",
  props: {
    artifacts: {
      type: Object as PropType<Artifacts>,
      required: true
    }
  },
  components: { Artifact, Pagination },
  emits: ["update-page"],
  setup(props, context) {
    const hasArtifacts = computed(() => {
      return props.artifacts.results.length > 0
    })

    const onUpdatePage = (page: number) => {
      context.emit("update-page", page)
    }

    const onDelete = () => {
      context.emit("update-page", 1)
    }

    return { onUpdatePage, onDelete, hasArtifacts }
  }
})
</script>
