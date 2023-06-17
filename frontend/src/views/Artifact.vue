<template>
  <Artifact :id="artifactId"></Artifact>
</template>

<script lang="ts">
import { useTitle } from "@vueuse/core";
import { defineComponent, onMounted, ref, watch } from "vue";

import Artifact from "@/components/artifact/ArtifactWrapper.vue";

export default defineComponent({
  name: "ArtifactView",
  components: {
    Artifact,
  },
  props: {
    id: {
      type: String,
      required: true,
    },
  },
  setup(props) {
    const artifactId = ref<string>(props.id);

    const updateTitle = () => {
      useTitle(`Artifact:${artifactId.value} - Mihari`);
    };

    onMounted(() => {
      updateTitle();
    });

    watch(
      () => props.id,
      () => {
        artifactId.value = props.id;
        updateTitle();
      }
    );

    return { artifactId };
  },
});
</script>
