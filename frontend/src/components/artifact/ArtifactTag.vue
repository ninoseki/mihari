<template>
  <div class="control" v-if="!isDeleted">
    <div
      class="tags has-addons are-medium"
      v-on:mouseover="showDeleteButton"
      v-on:mouseleave="hideDeleteButton"
    >
      <router-link
        class="tag is-link is-light"
        :to="{ name: 'Artifact', params: { id: artifact.id } }"
        >{{ artifact.data }}</router-link
      >
      <span
        class="tag is-delete"
        v-if="isDeleteButtonEnabled"
        @click="deleteArtifact"
      ></span>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType, ref } from "vue";

import { generateDeleteArtifactTask } from "@/api-helper";
import { Artifact } from "@/types";

export default defineComponent({
  name: "ArtifactTag",
  props: {
    artifact: {
      type: Object as PropType<Artifact>,
      required: true,
    },
  },
  setup(props) {
    const isDeleted = ref(false);
    const isDeleteButtonEnabled = ref(false);

    const deleteArtifactTask = generateDeleteArtifactTask();

    const deleteArtifact = async () => {
      const result = window.confirm(
        `Are you sure you want to delete ${props.artifact.data}?`
      );

      if (result) {
        await deleteArtifactTask.perform(props.artifact.id);
        isDeleted.value = true;
      }
    };

    const showDeleteButton = () => {
      isDeleteButtonEnabled.value = true;
    };

    const hideDeleteButton = () => {
      isDeleteButtonEnabled.value = false;
    };

    return {
      isDeleted,
      deleteArtifact,
      showDeleteButton,
      hideDeleteButton,
      isDeleteButtonEnabled,
    };
  },
});
</script>
