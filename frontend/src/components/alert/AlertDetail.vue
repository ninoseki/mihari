<script setup lang="ts">
import type { HTTPError } from "ky"
import { type PropType, ref } from "vue"

import ActionButtons from "@/components/alert/ActionButtons.vue"
import Alerts from "@/components/alert/AlertsWithPagination.vue"
import Artifacts from "@/components/artifact/ArtifactTags.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Tags from "@/components/tag/TagsItem.vue"
import type { AlertType } from "@/schemas"

defineProps({
  alert: {
    type: Object as PropType<AlertType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "delete"): void
}>()

const error = ref<HTTPError>()

const onSetError = (newError: HTTPError) => {
  error.value = newError
}

const onDisposeError = () => {
  error.value = undefined
}

const onDelete = () => {
  emits("delete")
}

const onArtifactsDeleted = onDelete
</script>

<template>
  <ErrorMessage
    class="block"
    :error="error"
    v-if="error"
    :disposable="true"
    @dispose="onDisposeError"
  />
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
          <Artifacts :artifacts="alert.artifacts" @delete="onArtifactsDeleted" />
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
    <Alerts :rule-id="alert.ruleId" :exclude-alert-id="alert.id" />
  </div>
</template>
