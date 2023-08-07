<template>
  <EditRule :id="id"></EditRule>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core"
import { defineComponent, onMounted, watch } from "vue"

import EditRule from "@/components/rule/EditRuleWrapper.vue"

export default defineComponent({
  name: "EditRuleView",
  components: {
    EditRule
  },
  props: {
    id: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const updateTitle = () => {
      useTitle(`Edit rule:${props.id} - Mihari`)
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
