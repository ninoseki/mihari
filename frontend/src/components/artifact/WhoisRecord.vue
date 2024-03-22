<template>
  <div class="field is-grouped is-grouped-multiline">
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Registrar</span>
        <span class="tag">{{ whoisRecord.registrar?.name || "N/A" }}</span>
      </div>
    </div>
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Created on</span>
        <span class="tag">{{ whoisRecord.createdOn || "N/A" }}</span>
      </div>
    </div>
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Updated on</span>
        <span class="tag">{{ whoisRecord.updatedOn || "N/A" }}</span>
      </div>
    </div>
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Expires on</span>
        <span class="tag">{{ whoisRecord.expiresOn || "N/A" }}</span>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { WhoisRecordType } from "@/schemas"

export default defineComponent({
  name: "WhoisRecord",
  props: {
    whoisRecord: {
      type: Object as PropType<WhoisRecordType>,
      required: true
    }
  }
})
</script>
