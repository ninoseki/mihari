<template>
  <div class="field is-grouped is-grouped-multiline">
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Registrar</span>
        <span class="tag is-light">{{
          whoisRecord.registrar?.name || "N/A"
        }}</span>
      </div>
    </div>

    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Created on</span>
        <span class="tag is-light">{{ whoisRecord.createdOn || "N/A" }}</span>
      </div>
    </div>

    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Updated on</span>
        <span class="tag is-light">{{ whoisRecord.updatedOn || "N/A" }}</span>
      </div>
    </div>

    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Exipres on</span>
        <span class="tag is-light">{{ whoisRecord.expiresOn || "N/A" }}</span>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";

import { WhoisRecord } from "@/types";

export default defineComponent({
  name: "WhoisRecord",
  props: {
    whoisRecord: {
      type: Object as PropType<WhoisRecord>,
      required: true,
    },
  },
});
</script>
