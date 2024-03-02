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
    <YAML :yaml="rule.yaml" />
  </div>
  <hr />
  <div class="block">
    <h2 class="is-size-2 block">Alerts</h2>
    <Alerts :ruleId="rule.id" />
  </div>
</template>

<script lang="ts">
import type { AxiosError } from "axios"
import { defineComponent, type PropType, ref } from "vue"

import Alerts from "@/components/alert/AlertsWithPagination.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Message from "@/components/Message.vue"
import ActionButtons from "@/components/rule/ActionButtons.vue"
import YAML from "@/components/rule/YAML.vue"
import type { QueueMessageType, RuleType } from "@/schemas"

export default defineComponent({
  name: "RuleDetailItem",
  props: {
    rule: {
      type: Object as PropType<RuleType>,
      required: true
    }
  },
  components: {
    YAML,
    Alerts,
    ErrorMessage,
    Message,
    ActionButtons
  },
  emits: ["delete", "refresh"],
  setup(_, context) {
    const error = ref<AxiosError>()
    const message = ref<QueueMessageType>()

    const onDelete = () => {
      context.emit("delete")
    }

    const onSetError = (newError: AxiosError) => {
      error.value = newError
    }

    const onDisposeError = () => {
      error.value = undefined
    }

    const onSetMessage = (newMessage: QueueMessageType) => {
      if (newMessage.queued) {
        message.value = newMessage
      } else {
        context.emit("refresh")
      }
    }

    const onDisposeMessage = () => {
      message.value = undefined
    }

    const onRefresh = () => {
      context.emit("refresh")
    }

    return {
      onSetMessage,
      onDisposeMessage,
      message,
      onSetError,
      error,
      onDisposeError,
      onDelete,
      onRefresh
    }
  }
})
</script>
