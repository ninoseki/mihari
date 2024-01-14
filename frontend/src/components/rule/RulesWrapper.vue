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
          Searchable fields are <code>id</code>, <code>title</code>, <code>description</code>,
          <code>tag</code>, <code>created_at</code> and <code>updated_at</code>.
        </li>
      </ul>
      <h4 class="is-size-4">Examples</h4>
      <ul>
        <li>
          <router-link
            :to="{ name: 'Rules', query: { q: 'title:foo AND created_at >= 2020-01-01' } }"
            >title:foo AND created_at >= 2020-01-01</router-link
          >
        </li>
      </ul>
    </div>
  </div>
  <div class="block" v-if="getRulesTask.performCount > 0">
    <Loading v-if="getRulesTask.isRunning"></Loading>
    <ErrorMessage v-if="getRulesTask.isError" :error="getRulesTask.last?.error"></ErrorMessage>
    <Rules
      :rules="getRulesTask.last.value"
      v-if="getRulesTask.last?.value"
      @update-page="onUpdatePage"
      @refresh="onRefresh"
    ></Rules>
  </div>
</template>

<script lang="ts">
import { useRouteQuery } from "@vueuse/router"
import { defineComponent, onMounted, ref, watch } from "vue"

import { generateGetRulesTask } from "@/api-helper"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"
import Rules from "@/components/rule/Rules.vue"
import type { SearchParams } from "@/types"

export default defineComponent({
  name: "RulesWrapper",
  components: {
    Rules,
    Loading,
    ErrorMessage
  },
  setup() {
    const page = useRouteQuery<string>("page", "1")
    const q = useRouteQuery<string>("q", "")
    const showHelp = ref(false)

    const getRulesTask = generateGetRulesTask()

    const getRules = async () => {
      const params: SearchParams = { q: q.value, page: parseInt(page.value) }
      return await getRulesTask.perform(params)
    }

    const onUpdatePage = (newPage: number) => {
      page.value = newPage.toString()
    }

    const search = async () => {
      page.value = "1"
      await getRules()
    }

    const onRefresh = search

    const toggleShowHelp = () => {
      showHelp.value = !showHelp.value
    }

    onMounted(async () => {
      await getRules()
    })

    watch(page, async () => {
      await getRules()
    })

    watch(q, async () => {
      window.scrollTo({
        top: 0,
        behavior: "smooth"
      })
    })

    return {
      getRulesTask,
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
