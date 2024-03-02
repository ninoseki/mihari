<template>
  <div class="box" v-if="!isDeleted">
    <ErrorMessage
      class="block"
      :error="error"
      v-if="error"
      :disposable="true"
      @dispose="onDisposeError"
    ></ErrorMessage>
    <p>
      <ActionButtons :alert="alert" @delete="onDelete" @set-error="onSetError"></ActionButtons>
    </p>
    <router-link class="is-size-4" :to="{ name: 'Alert', params: { id: alert.id } }">{{
      alert.id
    }}</router-link>
    <table class="table is-fullwidth is-completely-borderless">
      <tr>
        <th>Rule</th>
        <td>
          <router-link :to="{ name: 'Rule', params: { id: alert.ruleId } }">{{
            alert.ruleId
          }}</router-link>
        </td>
      </tr>
      <tr>
        <th>Artifacts</th>
        <td>
          <Artifacts :artifacts="alert.artifacts" @delete="onArtifactsDeleted"></Artifacts>
        </td>
      </tr>
      <tr v-if="alert.tags.length > 0">
        <th>Tags</th>
        <td>
          <Tags :tags="alert.tags" :navigate-to="'Alerts'"></Tags>
        </td>
      </tr>
    </table>
    <p class="help">Created at: {{ alert.createdAt }}</p>
  </div>
</template>

<script lang="ts">
import type { AxiosError } from "axios"
import { defineComponent, type PropType, ref } from "vue"

import ActionButtons from "@/components/alert/ActionButtons.vue"
import Artifacts from "@/components/artifact/ArtifactTags.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Tags from "@/components/tag/Tags.vue"
import type { AlertType } from "@/schemas"
import { getHumanizedRelativeTime, getLocalDatetime } from "@/utils"

export default defineComponent({
  name: "AlertItem",
  components: {
    Artifacts,
    Tags,
    ActionButtons,
    ErrorMessage
  },
  props: {
    alert: {
      type: Object as PropType<AlertType>,
      required: true
    }
  },
  emits: ["delete"],
  setup(_, context) {
    const isDeleted = ref(false)
    const error = ref<AxiosError>()

    const onSetError = (newError: AxiosError) => {
      error.value = newError
    }

    const onDisposeError = () => {
      error.value = undefined
    }

    const onDelete = () => {
      context.emit("delete")
    }

    const onArtifactsDeleted = () => {
      isDeleted.value = true
    }

    return {
      onDelete,
      getLocalDatetime,
      getHumanizedRelativeTime,
      onSetError,
      onDisposeError,
      error,
      isDeleted,
      onArtifactsDeleted
    }
  }
})
</script>
