<template>
  <div class="block">
    <h2 class="is-size-2 block">{{ rule.id }}</h2>
    <ErrorMessage
      class="mt-3 mb-3"
      :error="error"
      v-if="error"
      :disposable="true"
      @dispose="onDisposeError"
    ></ErrorMessage>
    <MessageComponent
      class="block"
      :message="message"
      v-if="message"
      :disposable="true"
      @dispose="onDisposeMessage"
    ></MessageComponent>
    <p class="block is-clearfix">
      <ActionButtons
        :rule="rule"
        @set-message="onSetMessage"
        @delete="onDelete"
        @set-error="onSetError"
      />
    </p>
    <YAML :yaml="rule.yaml"></YAML>
  </div>
  <hr />
  <div class="block">
    <h2 class="is-size-2 block">Alerts</h2>
    <Alerts :ruleId="rule.id"></Alerts>
  </div>
</template>

<script lang="ts">
import type { AxiosError } from "axios"
import { defineComponent, type PropType, ref } from "vue"

import Alerts from "@/components/alert/AlertsWithPagination.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import MessageComponent from "@/components/Message.vue"
import ActionButtons from "@/components/rule/ActionButtons.vue"
import YAML from "@/components/rule/YAML.vue"
import type { Message, QueueMessage, Rule } from "@/types"

export default defineComponent({
  name: "RuleDetailItem",
  props: {
    rule: {
      type: Object as PropType<Rule>,
      required: true
    }
  },
  components: {
    YAML,
    Alerts,
    ErrorMessage,
    MessageComponent,
    ActionButtons
  },
  emits: ["delete", "refresh"],
  setup(_, context) {
    const error = ref<AxiosError>()
    const message = ref<Message>()

    const onDelete = () => {
      context.emit("delete")
    }

    const onSetError = (newError: AxiosError) => {
      error.value = newError
    }

    const onDisposeError = () => {
      error.value = undefined
    }

    const onSetMessage = (newMessage: QueueMessage) => {
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
