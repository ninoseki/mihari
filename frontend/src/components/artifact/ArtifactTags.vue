<template>
  <div class="field is-grouped is-grouped-multiline">
    <ArtifactTag
      v-for="artifact in artifacts"
      :key="artifact.id"
      :artifact="artifact"
      @delete="onDelete"
    ></ArtifactTag>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType, ref, watch } from "vue"

import ArtifactTag from "@/components/artifact/ArtifactTag.vue"
import type { Artifact } from "@/types"

export default defineComponent({
  name: "ArtifactTags",
  components: {
    ArtifactTag
  },
  props: {
    artifacts: {
      type: Array as PropType<Artifact[]>,
      required: true
    }
  },
  emits: ["delete"],
  setup(props, context) {
    const count = ref(0)

    const onDelete = () => {
      count.value += 1
    }

    watch(count, () => {
      // Emit "delete" when all the artifacts are deleted
      if (count.value >= props.artifacts.length) {
        context.emit("delete")
      }
    })

    return { onDelete }
  }
})
</script>
