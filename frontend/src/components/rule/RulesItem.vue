<script setup lang="ts">
import { computed, type PropType } from "vue"

import Pagination from "@/components/PaginationItem.vue"
import Rule from "@/components/rule/RuleItem.vue"
import type { RulesType } from "@/schemas"

const props = defineProps({
  rules: {
    type: Object as PropType<RulesType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "refresh"): void
  (e: "update-page", value: number): void
}>()

const onUpdatePage = (page: number) => {
  emits("update-page", page)
}

const onRefresh = () => {
  emits("refresh")
}

const hasRules = computed(() => {
  return props.rules.results.length > 0
})
</script>

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
