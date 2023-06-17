<template>
  <div class="tags are-medium">
    <router-link
      class="tag"
      v-for="reverseDnsName in reverseDnsNames"
      :key="reverseDnsName.name"
      :to="{
        name: 'Alerts',
        query: { reverseDnsName: reverseDnsName.name },
      }"
    >
      {{ reverseDnsName.name }}
    </router-link>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";

import { ReverseDnsName } from "@/types";

export default defineComponent({
  name: "ReverseDnsNames",
  props: {
    reverseDnsNames: {
      type: Array as PropType<ReverseDnsName[]>,
      required: true,
    },
  },
});
</script>
