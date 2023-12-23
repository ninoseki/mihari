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
    <div class="content" v-if="showHelp">
      <h4 class="is-size-4">Help</h4>
      <ul>
        <li>
          You can group and concatenate search terms with brackets <code>( )</code>,
          <code>AND</code>, <code>OR</code> and <code>NOT</code>.
        </li>
        <li>
          Searchable fields are
          <code>rule.id</code>, <code>rule.tittle</code>, <code>rule.description</code>,
          <code>artifact.data</code> <code>artifact.data_type</code>, <code>artifact.source</code>,
          <code>tag</code>, <code>created_at</code> and <code>updated_at</code>.
        </li>
      </ul>
      <h4 class="is-size-4">Examples</h4>
      <ul>
        <li>
          <router-link
            :to="{ name: 'Alerts', query: { q: 'rule.id:foo AND artifact.data:example.com' } }"
            >rule.id:foo AND artifact.data:example.com</router-link
          >
        </li>
        <li>
          <router-link
            :to="{ name: 'Alerts', query: { q: 'tag:foo AND created_at >= 2020-01-01' } }"
            >tag:foo AND created_at >= 2020-01-01</router-link
          >
        </li>
      </ul>
    </div>
  </div>
  <div class="block" v-if="getAlertsTask.performCount > 0">
    <Loading v-if="getAlertsTask.isRunning"></Loading>
    <ErrorMessage v-if="getAlertsTask.isError" :error="getAlertsTask.last?.error"></ErrorMessage>
    <AlertsComponent
      :alerts="getAlertsTask.last.value"
      v-if="getAlertsTask.last?.value"
      :page="page"
      @refresh-page="onRefreshPage"
      @update-page="onUpdatePage"
    ></AlertsComponent>
  </div>
</template>

<script lang="ts">
import { useRouteQuery } from "@vueuse/router"
import { defineComponent, onMounted, ref, watch } from "vue"

import { generateGetAlertsTask } from "@/api-helper"
import AlertsComponent from "@/components/alert/Alerts.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"
import type { SearchParams } from "@/types"

export default defineComponent({
  name: "AlertsWrapper",
  components: {
    AlertsComponent,
    Loading,
    ErrorMessage
  },
  setup() {
    const page = useRouteQuery<string>("page", "1")
    const q = useRouteQuery<string>("q", "")
    const showHelp = ref(false)

    const getAlertsTask = generateGetAlertsTask()

    const getAlerts = async () => {
      const params: SearchParams = { q: q.value, page: parseInt(page.value) }
      return await getAlertsTask.perform(params)
    }

    const onUpdatePage = (newPage: number) => {
      page.value = newPage.toString()
    }

    const resetPage = () => {
      page.value = "1"
    }

    const onRefreshPage = async () => {
      // it is just an alias of search
      // this function will be invoked when an alert is deleted
      await search()
    }

    const search = async () => {
      resetPage()
      await getAlerts()
    }

    const toggleShowHelp = () => {
      showHelp.value = !showHelp.value
    }

    onMounted(async () => {
      await getAlerts()
    })

    watch(page, async () => {
      await getAlerts()
    })

    return {
      getAlertsTask,
      page,
      q,
      onRefreshPage,
      search,
      showHelp,
      toggleShowHelp,
      onUpdatePage
    }
  }
})
</script>
