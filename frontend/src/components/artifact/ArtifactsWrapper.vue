<template>
  <div class="block">
    <div class="field has-addons">
      <p class="control is-expanded">
        <input class="input" type="text" v-model="q" />
      </p>
      <p class="control">
        <a class="button is-primary" @click="search">
          <span class="icon is-small">
            <font-awesome-icon icon="search"></font-awesome-icon>
          </span>
          <span>Search</span>
        </a>
      </p>
      <p class="control">
        <a class="button is-info" @click="toggleShowHelp">
          <span class="icon is-small">
            <font-awesome-icon icon="question"></font-awesome-icon>
          </span>
          <span>Help</span>
        </a>
      </p>
    </div>
    <div class="content mt-3" v-if="showHelp">
      <h4 class="is-size-4">Help</h4>
      <ul>
        <li>
          Search query supports <code>AND</code>, <code>OR</code>, <code>:</code>, <code>=</code>,
          <code>!=</code>, <code>&lt;</code>, <code>&lt;=</code>, <code>&gt;</code>,
          <code>&gt;=</code>, <code>NOT</code> and <code>()</code>.
        </li>
        <li>
          <code>id</code>, <code>data</code>, <code>data_type</code>, <code>source</code>,
          <code>query</code>, <code>tag</code>, <code>rule.id</code>, <code>rule.title</code>,
          <code>rule.description</code>, <code>tag</code>,<code>created_at</code>, <code>asn</code>,
          <code>country_code</code>, <code>dns_record.value</code>,
          <code>dns_record.resource</code>, <code>reverse_dns_name</code>, <code>cpe</code>,
          <code>vuln</code> and <code>port</code>.
        </li>
      </ul>
    </div>
  </div>
  <div class="block" v-if="getArtifactsTask.performCount > 0">
    <Loading v-if="getArtifactsTask.isRunning"></Loading>
    <ErrorMessage
      v-if="getArtifactsTask.isError"
      :error="getArtifactsTask.last?.error"
    ></ErrorMessage>
    <Artifacts
      :artifacts="getArtifactsTask.last.value"
      v-if="getArtifactsTask.last?.value"
      @update-page="onUpdatePage"
      @refresh="onRefresh"
    ></Artifacts>
  </div>
</template>

<script lang="ts">
import { useRouteQuery } from "@vueuse/router"
import { defineComponent, onMounted, ref, watch } from "vue"

import { generateGetArtifactsTask } from "@/api-helper"
import Artifacts from "@/components/artifact/Artifacts.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"
import type { SearchParams } from "@/types"

export default defineComponent({
  name: "ArtifactsWrapper",
  components: {
    Artifacts,
    Loading,
    ErrorMessage
  },
  setup() {
    const page = useRouteQuery<string>("page", "1")
    const q = useRouteQuery<string>("q", "")
    const showHelp = ref(false)

    const getArtifactsTask = generateGetArtifactsTask()

    const getArtifacts = async () => {
      const params: SearchParams = { q: q.value, page: parseInt(page.value) }
      return await getArtifactsTask.perform(params)
    }

    const onUpdatePage = (newPage: number) => {
      console.log(newPage)
      page.value = newPage.toString()
    }

    const search = async () => {
      page.value = "1"
      await getArtifacts()
    }

    const onRefresh = search

    const toggleShowHelp = () => {
      showHelp.value = !showHelp.value
    }

    onMounted(async () => {
      await getArtifacts()
    })

    watch(page, async () => {
      await getArtifacts()
    })

    return {
      getArtifactsTask,
      page,
      q,
      search,
      showHelp,
      toggleShowHelp,
      onUpdatePage,
      onRefresh
    }
  }
})
</script>
