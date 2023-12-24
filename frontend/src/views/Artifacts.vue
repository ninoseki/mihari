<template>
  <Artifacts />
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core"
import { defineComponent, onMounted, watch } from "vue"

import Artifacts from "@/components/artifact/ArtifactsWrapper.vue"

export default defineComponent({
  name: "ArtifactsView",
  components: {
    Artifacts
  },
  setup(props) {
    const updateTitle = () => {
      useTitle(`Artifacts - Mihari`)
    }

    onMounted(() => {
      updateTitle()
    })

    watch(
      () => props.id,
      () => {
        updateTitle()
      }
    )
  }
})
</script>
