<template>
  <Artifact :id="parseInt(id)"></Artifact>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core"
import { defineComponent, onMounted, watch } from "vue"

import Artifact from "@/components/artifact/ArtifactDetailWrapper.vue"

export default defineComponent({
  name: "ArtifactView",
  components: {
    Artifact
  },
  props: {
    id: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const updateTitle = () => {
      useTitle(`Artifact:${props.id} - Mihari`)
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
