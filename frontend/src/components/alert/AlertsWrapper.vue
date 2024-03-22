<template>
  <div class="block">
    <div class="field has-addons">
      <p class="control is-expanded">
        <input class="input" type="text" v-model="q" />
      </p>
      <p class="control">
        <a class="button is-primary" @click="search">
          <span class="icon is-small">
            <font-awesome-icon icon="search" />
          </span>
          <span>Search</span>
        </a>
      </p>
      <p class="control">
        <a class="button is-info" @click="toggleShowHelp">
          <span class="icon is-small">
            <font-awesome-icon icon="question" />
          </span>
          <span>Help</span>
        </a>
      </p>
    </div>
    <div class="content" v-if="showHelp">
      <h4 class="is-size-4">Help</h4>
      <ul>
        <li>
          Search query supports <code>AND</code>, <code>OR</code>, <code>:</code>, <code>=</code>,
          <code>!=</code>, <code>&lt;</code>, <code>&lt;=</code>, <code>&gt;</code>,
          <code>&gt;=</code>, <code>NOT</code> and <code>()</code>.
        </li>
        <li>
          Searchable fields are <code>id</code>, <code>tag</code>, <code>created_at</code>,
          <code>rule.id</code>, <code>rule.title</code>, <code>rule.description</code>,
          <code>artifact.data</code>, <code>artifact.data_type</code>,
          <code>artifact.source</code> and <code>artifact.query</code>.
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
    <Loading v-if="getAlertsTask.isRunning" />
    <ErrorMessage v-if="getAlertsTask.isError" :error="getAlertsTask.last?.error" />
    <Alerts
      :alerts="getAlertsTask.last.value"
      v-if="getAlertsTask.last?.value"
      :page="page"
      @update-page="onUpdatePage"
      @refresh="onRefresh"
    />
  </div>
</template>

<script lang="ts">
import { useRouteQuery } from "@vueuse/router"
import { defineComponent, onMounted, ref, watch } from "vue"

import { generateGetAlertsTask } from "@/api-helper"
import Alerts from "@/components/alert/Alerts.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"
import type { SearchParamsType } from "@/schemas"

export default defineComponent({
  name: "AlertsWrapper",
  components: {
    Alerts,
    Loading,
    ErrorMessage
  },
  setup() {
    const page = useRouteQuery<string>("page", "1")
    const q = useRouteQuery<string>("q", "")
    const showHelp = ref(false)

    const getAlertsTask = generateGetAlertsTask()

    const getAlerts = async () => {
      const params: SearchParamsType = { q: q.value, page: parseInt(page.value) }
      return await getAlertsTask.perform(params)
    }

    const onUpdatePage = (newPage: number) => {
      page.value = newPage.toString()
    }

    const search = async () => {
      page.value = "1"
      await getAlerts()
    }

    // NOTE: Using onUpdatePage when deleting (= refreshing) does not work well if page equals to 1
    //       (Because page is not changed & it does not trigger getAlerts)
    const onRefresh = search

    const toggleShowHelp = () => {
      showHelp.value = !showHelp.value
    }

    onMounted(async () => {
      await getAlerts()
    })

    watch(page, async () => {
      await getAlerts()
    })

    watch(q, async () => {
      window.scrollTo({
        top: 0,
        behavior: "smooth"
      })
    })

    return {
      getAlertsTask,
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
