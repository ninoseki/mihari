<template>
  <div class="box">
    <table class="table is-fullwidth is-completely-borderless">
      <tr>
        <th>ID</th>
        <td>
          <p>
            <span class="buttons is-pulled-right">
              <a class="button is-link is-light is-small" :href="href" target="_blank">
                <span>JSON</span>
                <span class="icon is-small">
                  <font-awesome-icon icon="barcode"></font-awesome-icon>
                </span>
              </a>
              <button class="button is-light is-small" @click="deleteAlert">
                <span>Delete</span>
                <span class="icon is-small">
                  <font-awesome-icon icon="times"></font-awesome-icon>
                </span>
              </button>
            </span>
          </p>
          {{ alert.id }}
        </td>
      </tr>
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
          <Artifacts :artifacts="alert.artifacts"></Artifacts>
        </td>
      </tr>
      <tr v-if="alert.tags.length > 0">
        <th>Tags</th>
        <td>
          <Tags :tags="alert.tags"></Tags>
        </td>
      </tr>
    </table>
    <p class="help">Created at: {{ alert.createdAt }}</p>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent, type PropType } from "vue"

import { generateDeleteAlertTask } from "@/api-helper"
import Artifacts from "@/components/artifact/ArtifactTags.vue"
import Tags from "@/components/tag/Tags.vue"
import type { Alert } from "@/types"
import { getHumanizedRelativeTime, getLocalDatetime } from "@/utils"

export default defineComponent({
  name: "AlertItem",
  components: {
    Artifacts,
    Tags
  },
  props: {
    alert: {
      type: Object as PropType<Alert>,
      required: true
    }
  },
  emits: ["refresh-page"],
  setup(props, context) {
    const deleteAlertTask = generateDeleteAlertTask()

    const deleteAlert = async () => {
      const result = window.confirm(`Are you sure you want to delete ${props.alert.id}?`)

      if (result) {
        await deleteAlertTask.perform(props.alert.id)
        // refresh the page
        context.emit("refresh-page")
      }
    }

    const href = computed(() => {
      return `/api/alerts/${props.alert.id}`
    })

    return {
      href,
      deleteAlert,
      getLocalDatetime,
      getHumanizedRelativeTime
    }
  }
})
</script>
