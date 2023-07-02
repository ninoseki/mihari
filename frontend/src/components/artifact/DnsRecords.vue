<template>
  <div class="field is-grouped is-grouped-multiline">
    <div class="control" v-for="(dnsRecord, index) in dnsRecords" :key="index">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark"> {{ dnsRecord.resource }}</span>
        <router-link
          class="tag"
          :to="{
            name: 'Alerts',
            query: { dnsRecord: dnsRecord.value }
          }"
        >
          {{ truncate(dnsRecord.value, 50) }}
        </router-link>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import truncate from "truncate"
import { defineComponent, type PropType } from "vue"

import type { DnsRecord } from "@/types"

export default defineComponent({
  name: "DnsRecords",
  props: {
    dnsRecords: {
      type: Array as PropType<DnsRecord[]>,
      required: true
    }
  },
  setup() {
    return { truncate }
  }
})
</script>
