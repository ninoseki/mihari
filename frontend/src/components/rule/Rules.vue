<template>
  <ErrorMessage
    class="mt-3 mb-3"
    :error="error"
    v-if="error"
    :disposable="true"
    @dispose-error="disposeError"
  ></ErrorMessage>
  <div v-if="hasRules">
    <RuleComponent
      v-for="rule in rules.results"
      :rule="rule"
      :key="rule.id"
      @refresh="refresh"
      @set-error="setError"
    />
    <Pagination
      :currentPage="rules.currentPage"
      :total="rules.total"
      :pageSize="rules.pageSize"
      @update-page="updatePage"
    />
    <p class="help">({{ rules.total }} results in total, {{ rules.results.length }} shown)</p>
  </div>
  <div v-else>
    <div class="notification is-warning is-light">There is no alert to show</div>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent, type PropType, ref } from "vue"

import ErrorMessage from "@/components/ErrorMessage.vue"
import Pagination from "@/components/Pagination.vue"
import RuleComponent from "@/components/rule/Rule.vue"
import type { Rules } from "@/types"

export default defineComponent({
  name: "RulesItem",
  props: {
    rules: {
      type: Object as PropType<Rules>,
      required: true
    }
  },
  components: {
    Pagination,
    RuleComponent,
    ErrorMessage
  },
  emits: ["update-page", "refresh"],
  setup(props, context) {
    const error = ref<unknown>(undefined)

    const scrollToTop = () => {
      window.scrollTo({
        top: 0
      })
    }

    const updatePage = (page: number) => {
      scrollToTop()
      context.emit("update-page", page)
    }

    const refresh = () => {
      context.emit("refresh")
    }

    const setError = (newError: unknown) => {
      error.value = newError
    }

    const disposeError = () => {
      error.value = undefined
    }

    const hasRules = computed(() => {
      return props.rules.results.length > 0
    })

    return { updatePage, refresh, hasRules, setError, error, disposeError }
  }
})
</script>
