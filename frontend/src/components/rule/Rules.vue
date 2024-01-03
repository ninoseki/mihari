<template>
  <div class="block" v-if="hasRules">
    <Rule
      v-for="rule in rules.results"
      :rule="rule"
      :key="rule.id"
      @refresh="onRefresh"
      @delete="onRefresh"
    />
    <Pagination
      :currentPage="rules.currentPage"
      :total="rules.total"
      :pageSize="rules.pageSize"
      @update-page="onUpdatePage"
    />
    <p class="help">({{ rules.total }} results in total, {{ rules.results.length }} shown)</p>
  </div>
  <div class="block" v-else>
    <div class="notification is-warning is-light">There is no alert to show</div>
  </div>
</template>

<script lang="ts">
import type { AxiosError } from "axios"
import { computed, defineComponent, type PropType, ref } from "vue"

import Pagination from "@/components/Pagination.vue"
import Rule from "@/components/rule/Rule.vue"
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
    Rule
  },
  emits: ["update-page", "refresh"],
  setup(props, context) {
    const error = ref<AxiosError>()

    const onUpdatePage = (page: number) => {
      context.emit("update-page", page)
    }

    const onRefresh = () => {
      context.emit("refresh")
    }

    const hasRules = computed(() => {
      return props.rules.results.length > 0
    })

    return { onUpdatePage, onRefresh, hasRules, error }
  }
})
</script>
