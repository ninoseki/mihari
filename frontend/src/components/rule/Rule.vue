<template>
  <div class="box">
    <ErrorMessage
      class="block"
      :error="error"
      v-if="error"
      :disposable="true"
      @dispose="onDisposeError"
    ></ErrorMessage>
    <div class="block">
      <p>
        <ActionButtons
          :rule="rule"
          @set-error="onSetError"
          @delete="onDelete"
          @refresh="onRefresh"
        />
      </p>
      <router-link class="is-size-4" :to="{ name: 'Rule', params: { id: rule.id } }">{{
        rule.id
      }}</router-link>
    </div>
    <table class="table is-fullwidth is-completely-borderless">
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
import type { AxiosError } from "axios"
import { defineComponent, type PropType, ref } from "vue"

import ErrorMessage from "@/components/ErrorMessage.vue"
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
  components: { ActionButtons, Tags, ErrorMessage },
  emits: ["refresh", "delete"],
  setup(_, context) {
    const error = ref<AxiosError | undefined>()

    const onSetError = (newError: AxiosError) => {
      error.value = newError
    }

    const onDisposeError = () => {
      error.value = undefined
    }

    const onRefresh = () => {
      context.emit("refresh")
    }

    const onDelete = () => {
      context.emit("delete")
    }

    return { onSetError, onDisposeError, onRefresh, onDelete, error }
  }
})
</script>
