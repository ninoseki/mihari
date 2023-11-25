<template>
  <div class="column">
    <h2 class="is-size-2 mb-4">Artifact</h2>
    <div class="columns">
      <div
        class="column is-half"
        v-if="googleMapSrc !== undefined || urlscanLiveshotSrc !== undefined"
      >
        <div v-if="googleMapSrc">
          <h4 class="is-size-4 mb-2">
            Geolocation
            <span class="has-text-grey">{{
              countryCode || artifact.geolocation?.countryCode
            }}</span>
          </h4>
          <iframe class="mb-4" :src="googleMapSrc" width="100%" height="240px"></iframe>
        </div>
        <div v-if="urlscanLiveshotSrc">
          <h4 class="is-size-4 mb-2">
            Live screenshot
            <span class="has-text-grey">Hover to expand</span>
          </h4>
          <img :src="urlscanLiveshotSrc" class="liveshot" alt="liveshot" />
        </div>
      </div>
      <div class="column">
        <div class="block">
          <h4 class="is-size-4 mb-2">Information</h4>
          <span class="buttons is-pulled-right">
            <a class="button is-link is-light is-small" :href="href" target="_blank">
              <span>JSON</span>
              <span class="icon is-small">
                <font-awesome-icon icon="barcode"></font-awesome-icon>
              </span>
            </a>
            <button
              class="button is-info is-light is-small"
              @click="flipShowMetadata"
              v-if="artifact.metadata"
            >
              <span>Metadata</span>
              <span class="icon is-small">
                <font-awesome-icon icon="info-circle"></font-awesome-icon>
              </span>
            </button>
            <button class="button is-primary is-light is-small" @click="enrichArtifact">
              <span>Enrich</span>
              <span class="icon is-small">
                <font-awesome-icon
                  icon="spinner"
                  spin
                  v-if="enrichArtifactTask.isRunning"
                ></font-awesome-icon>
                <font-awesome-icon icon="lightbulb" v-else></font-awesome-icon>
              </span>
            </button>

            <button class="button is-light is-small" @click="deleteArtifact">
              <span>Delete</span>
              <span class="icon is-small">
                <font-awesome-icon icon="times"></font-awesome-icon>
              </span>
            </button>
          </span>
          <table class="table is-fullwidth is-completely-borderless">
            <tr>
              <th>ID</th>
              <td>
                {{ artifact.id }}
              </td>
            </tr>
            <tr>
              <th>Data type</th>
              <td>{{ artifact.dataType }}</td>
            </tr>
            <tr>
              <th>Data</th>
              <td>{{ truncate(artifact.data, 64) }}</td>
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
              <td><Tags :tags="artifact.tags"></Tags></td>
            </tr>
          </table>
        </div>
        <div v-if="artifact.metadata && showMetadata">
          <div class="modal is-active">
            <div class="modal-background" @click="flipShowMetadata"></div>
            <div class="modal-card">
              <header class="modal-card-head">
                <p class="modal-card-title">Metadata</p>
                <button class="delete" aria-label="close" @click="flipShowMetadata"></button>
              </header>
              <section class="modal-card-body">
                <VueJsonPretty :data="artifact.metadata"></VueJsonPretty>
              </section>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="block" v-if="artifact.autonomousSystem">
      <h4 class="is-size-4 mb-2">AS</h4>
      <AS :autonomousSystem="artifact.autonomousSystem"></AS>
    </div>
    <div class="block" v-if="artifact.reverseDnsNames">
      <h4 class="is-size-4 mb-2">Reverse DNS</h4>
      <ReverseDnsNames :reverseDnsNames="artifact.reverseDnsNames"></ReverseDnsNames>
    </div>
    <div class="block" v-if="artifact.dnsRecords">
      <h4 class="is-size-4 mb-2">DNS records</h4>
      <DnsRecords :dnsRecords="artifact.dnsRecords"></DnsRecords>
    </div>
    <div class="block" v-if="artifact.cpes">
      <h4 class="is-size-4 mb-2">CPEs</h4>
      <CPEs :cpes="artifact.cpes"></CPEs>
    </div>
    <div class="block" v-if="artifact.ports">
      <h4 class="is-size-4 mb-2">Ports</h4>
      <Ports :ports="artifact.ports"></Ports>
    </div>
    <div class="block" v-if="artifact.whoisRecord">
      <h4 class="is-size-4 mb-2">Whois record</h4>
      <WhoisRecord :whoisRecord="artifact.whoisRecord"></WhoisRecord>
    </div>
    <div class="block">
      <h4 class="is-size-4 mb-2">Links</h4>
      <Links :data="artifact.data" :type="artifact.dataType"></Links>
    </div>
  </div>
  <hr />
  <div class="column">
    <h2 class="is-size-2 mb-4">Related alerts</h2>
    <Alerts :artifact="artifact.data"></Alerts>
  </div>
</template>

<script lang="ts">
import "vue-json-pretty/lib/styles.css"

import truncate from "truncate"
import { computed, defineComponent, onMounted, type PropType, ref } from "vue"
import VueJsonPretty from "vue-json-pretty"
import { useRouter } from "vue-router"

import {
  generateDeleteArtifactTask,
  generateEnrichArtifactTask,
  generateGetAlertsTask,
  generateGetIPTask
} from "@/api-helper"
import Alerts from "@/components/alert/AlertsWithPagination.vue"
import AS from "@/components/artifact/AS.vue"
import CPEs from "@/components/artifact/CPEs.vue"
import DnsRecords from "@/components/artifact/DnsRecords.vue"
import Ports from "@/components/artifact/Ports.vue"
import ReverseDnsNames from "@/components/artifact/ReverseDnsNames.vue"
import Tags from "@/components/artifact/Tags.vue"
import WhoisRecord from "@/components/artifact/WhoisRecord.vue"
import Links from "@/components/link/Links.vue"
import type { ArtifactWithTags, GCS } from "@/types"
import { getGCSByCountryCode, getGCSByIPInfo } from "@/utils"

export default defineComponent({
  name: "ArtifactItem",
  props: {
    artifact: {
      type: Object as PropType<ArtifactWithTags>,
      required: true
    }
  },
  components: {
    Alerts,
    AS,
    DnsRecords,
    Links,
    ReverseDnsNames,
    Tags,
    VueJsonPretty,
    WhoisRecord,
    CPEs,
    Ports
  },
  emits: ["refresh"],
  setup(props, context) {
    const googleMapSrc = ref<string | undefined>(undefined)
    const countryCode = ref<string | undefined>(undefined)
    const showMetadata = ref(false)

    const href = computed(() => {
      return `/api/artifacts/${props.artifact.id}`
    })

    const router = useRouter()

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

    const getGoogleMapSrc = (gcs: GCS | undefined): string | undefined => {
      if (gcs !== undefined) {
        return `https://maps.google.co.jp/maps?output=embed&q=${gcs.lat},${gcs.long}&z=3`
      }

      return undefined
    }

    const getIPInfoTask = generateGetIPTask()
    const getAlertsTask = generateGetAlertsTask()
    const deleteArtifactTask = generateDeleteArtifactTask()
    const enrichArtifactTask = generateEnrichArtifactTask()

    const deleteArtifact = async () => {
      const result = window.confirm(`Are you sure you want to delete ${props.artifact.data}?`)

      if (result) {
        await deleteArtifactTask.perform(props.artifact.id)
        router.push("/")
      }
    }

    const enrichArtifact = async () => {
      await enrichArtifactTask.perform(props.artifact.id)
      context.emit("refresh")
    }

    const flipShowMetadata = () => {
      showMetadata.value = !showMetadata.value
    }

    onMounted(async () => {
      if (props.artifact.dataType === "ip") {
        let gcs: GCS | undefined = undefined

        if (props.artifact.geolocation === null) {
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

    return {
      countryCode,
      deleteArtifact,
      enrichArtifact,
      enrichArtifactTask,
      flipShowMetadata,
      getAlertsTask,
      googleMapSrc,
      href,
      showMetadata,
      truncate,
      urlscanLiveshotSrc
    }
  }
})
</script>

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

.modal-card {
  width: 960px;
}
</style>
