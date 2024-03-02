<template>
  <Rule :id="id" />
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core"
import { defineComponent, onMounted, watch } from "vue"

import Rule from "@/components/rule/RuleDetailWrapper.vue"

export default defineComponent({
  name: "RuleView",
  components: {
    Rule
  },
  props: {
    id: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const updateTitle = () => {
      useTitle(`Rule:${props.id} - Mihari`)
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
