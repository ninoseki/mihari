<template>
  <div class="columns">
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Title</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="text" v-model="title" />
            </p>
          </div>
        </div>
      </div>
    </div>
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Description</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="text" v-model="description" />
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="columns">
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Tag</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <div class="select">
                <select v-model="tagInput">
                  <option></option>
                  <option v-for="tag_ in tags" :key="tag_">
                    {{ tag_ }}
                  </option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="column"></div>
  </div>
  <div class="columns">
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">From</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="date" v-model="fromAt" />
            </p>
          </div>
        </div>
      </div>
    </div>
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">To</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="date" v-model="toAt" />
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { useRouteQuery } from "@vueuse/router"
import { defineComponent, type PropType, watch } from "vue"

import type { RuleSearchParams } from "@/types"
import { normalizeQuery } from "@/utils"

export default defineComponent({
  name: "RulesForm",
  props: {
    tags: {
      type: Array as PropType<string[]>,
      required: true
    },
    page: {
      type: String,
      required: true
    },
    tag: {
      type: String,
      required: false
    }
  },
  setup(props) {
    const description = useRouteQuery("description")
    const fromAt = useRouteQuery("fromAt")
    const tagInput = useRouteQuery("tag", props.tag || null)
    const title = useRouteQuery("title")
    const toAt = useRouteQuery("toAt")

    const getSearchParams = (): RuleSearchParams => {
      const params: RuleSearchParams = {
        description: normalizeQuery(description.value),
        page: parseInt(props.page),
        tag: normalizeQuery(tagInput.value),
        title: normalizeQuery(description.value),
        toAt: normalizeQuery(toAt.value),
        fromAt: normalizeQuery(fromAt.value)
      }
      return params
    }

    watch(
      () => props.tag,
      () => {
        tagInput.value = props.tag || null
      }
    )

    return {
      description,
      fromAt,
      getSearchParams,
      title,
      toAt,
      tagInput
    }
  }
})
</script>
