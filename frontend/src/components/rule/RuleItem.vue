<script setup lang="ts">
import type { AxiosError } from "axios"
import { type PropType, ref } from "vue"

import ErrorMessage from "@/components/ErrorMessage.vue"
import Message from "@/components/MessageItem.vue"
import ActionButtons from "@/components/rule/ActionButtons.vue"
import Tags from "@/components/tag/TagsItem.vue"
import type { QueueMessageType, RuleType } from "@/schemas"

defineProps({
  rule: {
    type: Object as PropType<RuleType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "delete"): void
}>()

const error = ref<AxiosError>()
const message = ref<QueueMessageType>()

const onSetError = (newError: AxiosError) => {
  error.value = newError
}

const onDisposeError = () => {
  error.value = undefined
}

const onSetMessage = (newMessage: QueueMessageType) => {
  message.value = newMessage
}

const onDisposeMessage = () => {
  message.value = undefined
}

const onDelete = () => {
  emits("delete")
}
</script>

<template>
  <div class="box">
    <ErrorMessage
      class="block"
      :error="error"
      v-if="error"
      :disposable="true"
      @dispose="onDisposeError"
    />
    <Message
      class="block"
      :message="message"
      v-if="message"
      :disposable="true"
      @dispose="onDisposeMessage"
    />
    <div class="block">
      <p>
        <ActionButtons
          :rule="rule"
          @set-error="onSetError"
          @delete="onDelete"
          @set-message="onSetMessage"
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
          <Tags :tags="rule.tags" :navigate-to="'Rules'" />
        </td>
      </tr>
    </table>
    <p class="block is-clearfix"></p>
    <p class="help">Created at: {{ rule.createdAt }}</p>
  </div>
</template>
