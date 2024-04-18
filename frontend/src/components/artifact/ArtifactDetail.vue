<script setup lang="ts">
import type { AxiosError } from "axios"
import truncate from "just-truncate"
import { computed, onMounted, type PropType, ref } from "vue"

import { generateGetIPTask } from "@/api-helper"
import ActionButtons from "@/components/artifact/ActionButtons.vue"
import AS from "@/components/artifact/AsItem.vue"
import CPEs from "@/components/artifact/CpesItem.vue"
import DnsRecords from "@/components/artifact/DnsRecordsItem.vue"
import Ports from "@/components/artifact/PortsItem.vue"
import ReverseDnsNames from "@/components/artifact/ReverseDnsNames.vue"
import Vulnerabilities from "@/components/artifact/VulnerabilitiesItem.vue"
import WhoisRecord from "@/components/artifact/WhoisRecord.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Links from "@/components/link/LinksItem.vue"
import Message from "@/components/MessageItem.vue"
import Tags from "@/components/tag/TagsItem.vue"
import type { ArtifactType, GcsType, QueueMessageType } from "@/schemas"
import { getGCSByCountryCode, getGCSByIPInfo } from "@/utils"

const props = defineProps({
  artifact: {
    type: Object as PropType<ArtifactType>,
    required: true
  }
})

const emits = defineEmits<{
  (e: "delete"): void
  (e: "refresh"): void
}>()

const googleMapSrc = ref<string>()
const countryCode = ref<string>()

const error = ref<AxiosError>()
const message = ref<QueueMessageType>()

const onSetError = (newError: AxiosError) => {
  error.value = newError
}

const onDisposeError = () => {
  error.value = undefined
}

const onDelete = () => {
  emits("delete")
}

const onSetMessage = (newMessage: QueueMessageType) => {
  if (newMessage.queued) {
    message.value = newMessage
  } else {
    emits("refresh")
  }
}

const onDisposeMessage = () => {
  message.value = undefined
}

const urlscanLiveshotSrc = computed<string | undefined>(() => {
  if (props.artifact.dataType === "domain") {
    const url = `http://${props.artifact.data}`
    return `https://urlscan.io/liveshot/?url=${url}`
  }

  if (props.artifact.dataType === "url") {
    return `https://urlscan.io/liveshot/?url=${props.artifact.data}`
  }

  return undefined
})

const getGoogleMapSrc = (gcs: GcsType | undefined): string | undefined => {
  if (gcs) {
    return `https://maps.google.co.jp/maps?output=embed&q=${gcs.lat},${gcs.long}&z=3`
  }

  return undefined
}

const getIPInfoTask = generateGetIPTask()

onMounted(async () => {
  if (props.artifact.dataType === "ip") {
    let gcs: GcsType | undefined = undefined

    if (!props.artifact.geolocation) {
      // Use IPInfo if an artifact does not have geolocation
      const ipinfo = await getIPInfoTask.perform(props.artifact.data)
      gcs = getGCSByIPInfo(ipinfo)
      countryCode.value = ipinfo.countryCode
    } else {
      gcs = getGCSByCountryCode(props.artifact.geolocation.countryCode)
    }

    googleMapSrc.value = getGoogleMapSrc(gcs)
  }
})
</script>

<template>
  <ErrorMessage
    class="block"
    :error="error"
    v-if="error"
    :disposable="true"
    @dispose="onDisposeError"
  />
  <Message
    class="block"
    :message="message"
    v-if="message"
    :disposable="true"
    @dispose="onDisposeMessage"
  />
  <div class="block">
    <h2 class="is-size-2">{{ artifact.id }}</h2>
    <p class="is-clearfix">
      <ActionButtons
        :artifact="artifact"
        @delete="onDelete"
        @set-error="onSetError"
        @set-message="onSetMessage"
      />
    </p>
  </div>
  <div class="columns">
    <div class="column is-half" v-if="googleMapSrc || urlscanLiveshotSrc">
      <div v-if="googleMapSrc">
        <h4 class="is-size-4">
          Geolocation
          <span class="has-text-grey">{{ countryCode || artifact.geolocation?.countryCode }}</span>
        </h4>
        <iframe class="mb-4" :src="googleMapSrc" width="100%" height="240px"></iframe>
      </div>
      <div v-if="urlscanLiveshotSrc">
        <h4 class="is-size-4">Live screenshot</h4>
        <p class="help">Hover to expand</p>
        <img :src="urlscanLiveshotSrc" class="liveshot" alt="liveshot" />
      </div>
    </div>
    <div class="column">
      <h4 class="is-size-4">Information</h4>
      <table class="table is-fullwidth is-completely-borderless">
        <tr>
          <th>Data</th>
          <td>{{ truncate(artifact.data, 64) }}</td>
        </tr>
        <tr>
          <th>Data type</th>
          <td>{{ artifact.dataType }}</td>
        </tr>
        <tr>
          <th>Source</th>
          <td>{{ artifact.source }}</td>
        </tr>
        <tr>
          <th>Query</th>
          <td>{{ truncate(artifact.query || "N/A", 64) }}</td>
        </tr>
        <tr v-if="artifact.tags.length > 0">
          <th>Tags</th>
          <td><Tags :tags="artifact.tags" :navigate-to="'Artifacts'" />/td></td>
        </tr>
      </table>
      <p class="help">Created at: {{ artifact.createdAt }}</p>
    </div>
  </div>
  <div class="block">
    <Links :data="artifact.data" :type="artifact.dataType" />
  </div>
  <div class="block">
    <div class="block" v-if="artifact.autonomousSystem">
      <h4 class="is-size-4 mb-2">AS</h4>
      <AS :autonomousSystem="artifact.autonomousSystem" />
    </div>
    <div class="block" v-if="artifact.reverseDnsNames">
      <h4 class="is-size-4 mb-2">Reverse DNS</h4>
      <ReverseDnsNames :reverseDnsNames="artifact.reverseDnsNames" />
    </div>
    <div class="block" v-if="artifact.dnsRecords">
      <h4 class="is-size-4 mb-2">DNS records</h4>
      <DnsRecords :dnsRecords="artifact.dnsRecords" />
    </div>
    <div class="block" v-if="artifact.cpes">
      <h4 class="is-size-4 mb-2">CPEs</h4>
      <CPEs :cpes="artifact.cpes" />
    </div>
    <div class="block" v-if="artifact.vulnerabilities">
      <h4 class="is-size-4 mb-2">Vulnerabilities</h4>
      <Vulnerabilities :vulnerabilities="artifact.vulnerabilities" />
    </div>
    <div class="block" v-if="artifact.ports">
      <h4 class="is-size-4 mb-2">Ports</h4>
      <Ports :ports="artifact.ports" />
    </div>
    <div class="block" v-if="artifact.whoisRecord">
      <h4 class="is-size-4 mb-2">Whois record</h4>
      <WhoisRecord :whoisRecord="artifact.whoisRecord" />
    </div>
  </div>
</template>

<style scoped>
img.liveshot {
  border: 1px solid #aaa;
  border-radius: 5px;
  width: 100%;
  max-height: 250px;
  object-fit: cover;
  object-position: top;
  display: block;
  overflow: hidden;
  transition:
    max-height 1s,
    height 1s;
}

img.liveshot:hover {
  max-height: none;
}
</style>
