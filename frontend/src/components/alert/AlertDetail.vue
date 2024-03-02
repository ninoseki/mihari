<template>
  <ErrorMessage
    class="block"
    :error="error"
    v-if="error"
    :disposable="true"
    @dispose="onDisposeError"
  ></ErrorMessage>
  <div class="block">
    <h2 class="is-size-2">{{ alert.id }}</h2>
    <p class="is-clearfix">
      <ActionButtons :alert="alert" @delete="onDelete" @set-error="onSetError" />
    </p>
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
  <hr />
  <div class="block">
    <h2 class="is-size-2 block">Related Alerts</h2>
    <Alerts :rule-id="alert.ruleId" :exclude-alert-id="alert.id"></Alerts>
  </div>
</template>

<script lang="ts">
import type { AxiosError } from "axios"
import { defineComponent, type PropType, ref } from "vue"

import ActionButtons from "@/components/alert/ActionButtons.vue"
import Alerts from "@/components/alert/AlertsWithPagination.vue"
import Artifacts from "@/components/artifact/ArtifactTags.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Tags from "@/components/tag/Tags.vue"
import type { AlertType } from "@/schemas"
import { getHumanizedRelativeTime, getLocalDatetime } from "@/utils"

export default defineComponent({
  name: "AlertDetail",
  components: {
    Artifacts,
    Tags,
    Alerts,
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

    const onArtifactsDeleted = onDelete

    return {
      onDelete,
      getLocalDatetime,
      getHumanizedRelativeTime,
      onSetError,
      onDisposeError,
      error,
      onArtifactsDeleted
    }
  }
})
</script>
