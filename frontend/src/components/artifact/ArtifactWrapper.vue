<template>
  <Loading v-if="getArtifactTask.isRunning"></Loading>

  <ErrorMessage
    v-if="getArtifactTask.isError"
    :error="getArtifactTask.last?.error"
  ></ErrorMessage>

  <ArtifactComponent
    :artifact="getArtifactTask.last.value"
    @refresh="refresh"
    v-if="getArtifactTask.last?.value"
  ></ArtifactComponent>
</template>

<script lang="ts">
import { defineComponent, onMounted, watch } from "vue";

import { generateGetArtifactTask } from "@/api-helper";
import ArtifactComponent from "@/components/artifact/Artifact.vue";
import ErrorMessage from "@/components/ErrorMessage.vue";
import Loading from "@/components/Loading.vue";

export default defineComponent({
  name: "ArtifactWrapper",
  components: {
    ArtifactComponent,
    Loading,
    ErrorMessage,
  },
  props: {
    id: {
      type: String,
      required: true,
    },
  },
  setup(props) {
    const getArtifactTask = generateGetArtifactTask();

    const getArtifact = async () => {
      await getArtifactTask.perform(props.id);
    };

    const refresh = async () => {
      await getArtifact();
    };

    onMounted(async () => {
      await getArtifact();
    });

    watch(props, async () => {
      await getArtifact();
    });

    return {
      getArtifactTask,
      refresh,
    };
  },
});
</script>
