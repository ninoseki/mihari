<template>
  <div class="box">
    <table class="table is-fullwidth is-completely-borderless">
      <tr>
        <th>ID</th>
        <td>
          {{ alert.id }}
          <button
            class="button is-light is-small is-pulled-right"
            @click="deleteAlert"
          >
            <span>Delete</span>
            <span class="icon is-small">
              <i class="fas fa-times"></i>
            </span>
          </button>
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
          <Tags :tags="alert.tags" @update-tag="updateTag"></Tags>
        </td>
      </tr>
    </table>
    <p class="help">Created at: {{ alert.createdAt }}</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";

import { generateDeleteAlertTask } from "@/api-helper";
import Artifacts from "@/components/artifact/ArtifactTags.vue";
import Tags from "@/components/tag/Tags.vue";
import { Alert } from "@/types";
import { getHumanizedRelativeTime, getLocalDatetime } from "@/utils";

export default defineComponent({
  name: "AlertItem",
  components: {
    Artifacts,
    Tags,
  },
  props: {
    alert: {
      type: Object as PropType<Alert>,
      required: true,
    },
  },
  setup(props, context) {
    const updateTag = (tag: string) => {
      context.emit("update-tag", tag);
    };

    const deleteAlertTask = generateDeleteAlertTask();

    const deleteAlert = async () => {
      const result = window.confirm(
        `Are you sure you want to delete ${props.alert.id}?`
      );

      if (result) {
        await deleteAlertTask.perform(props.alert.id);
        // refresh the page
        context.emit("refresh-page");
      }
    };

    return {
      updateTag,
      deleteAlert,
      getLocalDatetime,
      getHumanizedRelativeTime,
    };
  },
});
</script>
