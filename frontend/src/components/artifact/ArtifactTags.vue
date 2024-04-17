<script setup lang="ts">
import { type PropType, ref, watch } from "vue"

import ArtifactTag from "@/components/artifact/ArtifactTag.vue"
import type { ArtifactType } from "@/schemas"

const props = defineProps({
  artifacts: {
    type: Array as PropType<ArtifactType[]>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "delete"): void
}>()

const count = ref(0)

const onDelete = () => {
  count.value += 1
}

watch(count, () => {
  // Emit "delete" when all the artifacts are deleted
  if (count.value >= props.artifacts.length) {
    emits("delete")
  }
})
</script>

<template>
  <div class="field is-grouped is-grouped-multiline">
    <ArtifactTag
      v-for="artifact in artifacts"
      :key="artifact.id"
      :artifact="artifact"
      @delete="onDelete"
    />
  </div>
</template>
