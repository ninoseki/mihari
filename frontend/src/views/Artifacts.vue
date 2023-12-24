<template>
  <Artifacts />
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core"
import { defineComponent, onMounted } from "vue"

import Artifacts from "@/components/artifact/ArtifactsWrapper.vue"

export default defineComponent({
  name: "ArtifactsView",
  components: {
    Artifacts
  },
  setup() {
    const updateTitle = () => {
      useTitle(`Artifacts - Mihari`)
    }

    onMounted(() => {
      updateTitle()
    })
  }
})
</script>
