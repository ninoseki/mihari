<script setup lang="ts">
import type { AxiosError } from "axios"
import truncate from "just-truncate"
import { type PropType, ref } from "vue"

import ActionButtons from "@/components/artifact/ActionButtons.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Message from "@/components/MessageItem.vue"
import Tags from "@/components/tag/TagsItem.vue"
import type { ArtifactType, QueueMessageType } from "@/schemas"

defineProps({
  artifact: {
    type: Object as PropType<ArtifactType>,
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

const onDelete = () => {
  emits("delete")
  console.log("foo")
}

const onSetMessage = (newMessage: QueueMessageType) => {
  if (newMessage.queued) {
    message.value = newMessage
  }
}

const onDisposeMessage = () => {
  message.value = undefined
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
          :artifact="artifact"
          @delete="onDelete"
          @set-error="onSetError"
          @set-message="onSetMessage"
        />
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
          <Tags :tags="artifact.tags" :navigate-to="'Artifacts'" />
        </td>
      </tr>
    </table>
    <p class="block is-clearfix"></p>
    <p class="help">Created at: {{ artifact.createdAt }}</p>
  </div>
</template>
