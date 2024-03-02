<template>
  <div class="box">
    <ErrorMessage
      class="block"
      :error="error"
      v-if="error"
      :disposable="true"
      @dispose="onDisposeError"
    ></ErrorMessage>
    <Message
      class="block"
      :message="message"
      v-if="message"
      :disposable="true"
      @dispose="onDisposeMessage"
    ></Message>
    <div class="block">
      <p>
        <ActionButtons
          :artifact="artifact"
          @delete="onDelete"
          @set-error="onSetError"
          @set-message="onSetMessage"
        ></ActionButtons>
      </p>
      <router-link class="is-size-4" :to="{ name: 'Artifact', params: { id: artifact.id } }">{{
        artifact.id
      }}</router-link>
    </div>
    <table class="table is-fullwidth is-completely-borderless">
      <tr>
        <th>Data</th>
        <td>
          {{ artifact.data }}
        </td>
      </tr>
      <tr>
        <th>Data Type</th>
        <td>
          {{ artifact.dataType }}
        </td>
      </tr>
      <tr>
        <th>Source</th>
        <td>
          {{ artifact.source }}
        </td>
      </tr>
      <tr>
        <th>Query</th>
        <td>{{ truncate(artifact.query || "N/A", 64) }}</td>
      </tr>
      <tr v-if="artifact.tags.length > 0">
        <th>Tags</th>
        <td>
          <Tags :tags="artifact.tags" :navigate-to="'Artifacts'"></Tags>
        </td>
      </tr>
    </table>
    <p class="block is-clearfix"></p>
    <p class="help">Created at: {{ artifact.createdAt }}</p>
  </div>
</template>

<script lang="ts">
import type { AxiosError } from "axios"
import truncate from "just-truncate"
import { defineComponent, type PropType, ref } from "vue"

import ActionButtons from "@/components/artifact/ActionButtons.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Message from "@/components/Message.vue"
import Tags from "@/components/tag/Tags.vue"
import type { ArtifactType, QueueMessageType } from "@/schemas"

export default defineComponent({
  name: "ArtifactsItem",
  props: {
    artifact: {
      type: Object as PropType<ArtifactType>,
      required: true
    }
  },
  components: { ErrorMessage, ActionButtons, Message, Tags },
  emits: ["delete"],
  setup(_, context) {
    const error = ref<AxiosError>()
    const message = ref<QueueMessageType>()

    const onSetError = (newError: AxiosError) => {
      error.value = newError
    }

    const onDisposeError = () => {
      error.value = undefined
    }

    const onDelete = () => {
      context.emit("delete")
    }

    const onSetMessage = (newMessage: QueueMessageType) => {
      if (newMessage.queued) {
        message.value = newMessage
      }
    }

    const onDisposeMessage = () => {
      message.value = undefined
    }

    return {
      onSetError,
      onDisposeError,
      onDelete,
      error,
      truncate,
      message,
      onSetMessage,
      onDisposeMessage
    }
  }
})
</script>
