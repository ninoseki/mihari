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
          :artifact="artifact"
          @delete="onDelete"
          @set-error="onSetError"
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
    </table>
    <p class="block is-clearfix"></p>
    <p class="help">Created at: {{ artifact.createdAt }}</p>
  </div>
</template>

<script lang="ts">
import truncate from "truncate"
import { defineComponent, type PropType, ref } from "vue"

import ActionButtons from "@/components/artifact/ActionButtons.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import type { Artifact } from "@/types"

export default defineComponent({
  name: "ArtifactsItem",
  props: {
    artifact: {
      type: Object as PropType<Artifact>,
      required: true
    }
  },
  components: { ErrorMessage, ActionButtons },
  emits: ["delete"],
  setup(_, context) {
    const error = ref<unknown>(undefined)

    const onSetError = (newError: unknown) => {
      error.value = newError
    }

    const onDisposeError = () => {
      error.value = undefined
    }

    const onDelete = () => {
      context.emit("delete")
    }

    return { onSetError, onDisposeError, onDelete, error, truncate }
  }
})
</script>
