<script setup lang="ts">
import type { HTTPError } from "ky"
import { type PropType, ref } from "vue"

import Alerts from "@/components/alert/AlertsWithPagination.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Message from "@/components/MessageItem.vue"
import ActionButtons from "@/components/rule/ActionButtons.vue"
import Yaml from "@/components/rule/YamlItem.vue"
import type { QueueMessageType, RuleType } from "@/schemas"

defineProps({
  rule: {
    type: Object as PropType<RuleType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "delete"): void
  (e: "refresh"): void
}>()

const error = ref<HTTPError>()
const message = ref<QueueMessageType>()

const onDelete = () => {
  emits("delete")
}

const onSetError = (newError: HTTPError) => {
  error.value = newError
}

const onDisposeError = () => {
  error.value = undefined
}

const onSetMessage = (newMessage: QueueMessageType) => {
  if (newMessage.queued) {
    message.value = newMessage
  } else {
    emits("refresh")
  }
}

const onDisposeMessage = () => {
  message.value = undefined
}
</script>

<template>
  <div class="block">
    <h2 class="is-size-2 block">{{ rule.id }}</h2>
    <ErrorMessage
      class="mt-3 mb-3"
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
    <p class="block is-clearfix">
      <ActionButtons
        :rule="rule"
        @set-message="onSetMessage"
        @delete="onDelete"
        @set-error="onSetError"
      />
    </p>
    <Yaml :yaml="rule.yaml" />
  </div>
  <hr />
  <div class="block">
    <h2 class="is-size-2 block">Alerts</h2>
    <Alerts :ruleId="rule.id" />
  </div>
</template>
