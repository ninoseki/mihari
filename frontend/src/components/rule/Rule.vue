<template>
  <div class="box">
    <ErrorMessage
      class="block"
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
import MessageComponent from "@/components/Message.vue"
import ActionButtons from "@/components/rule/ActionButtons.vue"
import Tags from "@/components/tag/Tags.vue"
import type { Message, QueueMessage, Rule } from "@/types"

export default defineComponent({
  name: "RuleItem",
  props: {
    rule: {
      type: Object as PropType<Rule>,
      required: true
    }
  },
  components: { ActionButtons, Tags, ErrorMessage, MessageComponent },
  emits: ["delete"],
  setup(_, context) {
    const error = ref<AxiosError>()
    const message = ref<Message>()

    const onSetError = (newError: AxiosError) => {
      error.value = newError
    }

    const onDisposeError = () => {
      error.value = undefined
    }

    const onSetMessage = (newMessage: QueueMessage) => {
      message.value = newMessage
    }

    const onDisposeMessage = () => {
      message.value = undefined
    }

    const onDelete = () => {
      context.emit("delete")
    }

    return {
      onSetError,
      onDisposeError,
      onSetMessage,
      onDelete,
      error,
      message,
      onDisposeMessage
    }
  }
})
</script>
