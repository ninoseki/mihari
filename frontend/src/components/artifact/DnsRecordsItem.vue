<script setup lang="ts">
import truncate from "just-truncate"
import { type PropType } from "vue"

import type { DnsRecordType } from "@/schemas"

defineProps({
  dnsRecords: {
    type: Array as PropType<DnsRecordType[]>,
    required: true
  }
})

const getQuery = ({ resource, value }: { resource: string; value: string }) => {
  return `dns_record.value:"${value}" AND dns_record.resource:"${resource}"`
}
</script>

<template>
  <div class="field is-grouped is-grouped-multiline">
    <div class="control" v-for="(dnsRecord, index) in dnsRecords" :key="index">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark"> {{ dnsRecord.resource }}</span>
        <router-link
          class="tag"
          :to="{
            name: 'Artifacts',
            query: { q: getQuery({ resource: dnsRecord.resource, value: dnsRecord.value }) }
          }"
        >
          {{ truncate(dnsRecord.value, 50) }}</router-link
        >
      </div>
    </div>
  </div>
</template>
