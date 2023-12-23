<template>
  <Alert :id="parseInt(id)"></Alert>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core"
import { defineComponent, onMounted, watch } from "vue"

import Alert from "@/components/alert/AlertDetailWrapper.vue"

export default defineComponent({
  name: "AlertView",
  components: {
    Alert
  },
  props: {
    id: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const updateTitle = () => {
      useTitle(`Alert:${props.id} - Mihari`)
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
