<template>
  <div class="box">
    <table class="table is-fullwidth is-completely-borderless">
      <tr>
        <th>ID</th>
        <td>
          <p>
            <ActionButtons :rule="rule" @set-error="setError" />
          </p>
          <router-link :to="{ name: 'Rule', params: { id: rule.id } }">{{ rule.id }}</router-link>
        </td>
      </tr>
      <tr>
        <th>Title</th>
        <td>
          {{ rule.title }}
        </td>
      </tr>
      <tr>
        <th>Description</th>
        <td>
          {{ rule.description }}
        </td>
      </tr>
      <tr v-if="rule.tags.length > 0">
        <th>Tags</th>
        <td>
          <Tags :tags="rule.tags" />
        </td>
      </tr>
    </table>
    <p class="block is-clearfix"></p>
    <p class="help">Created at: {{ rule.createdAt }}</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import ActionButtons from "@/components/rule/ActionButtons.vue"
import Tags from "@/components/tag/Tags.vue"
import type { Rule } from "@/types"

export default defineComponent({
  name: "RuleItem",
  props: {
    rule: {
      type: Object as PropType<Rule>,
      required: true
    }
  },
  components: { ActionButtons, Tags },
  emits: ["set-error"],
  setup(_, context) {
    const setError = (newError: unknown) => {
      context.emit("set-error", newError)
    }

    return { setError }
  }
})
</script>
