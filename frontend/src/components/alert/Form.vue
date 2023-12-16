<template>
  <div class="columns">
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Rule</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <div class="select">
                <select v-model="ruleId">
                  <option></option>
                  <option v-for="ruleId_ in ruleSet" :key="ruleId_">
                    {{ ruleId_ }}
                  </option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Artifact</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="text" v-model="artifact" />
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

import type { AlertSearchParams } from "@/types"
import { normalizeQuery } from "@/utils"

export default defineComponent({
  name: "AlertsForm",
  props: {
    tags: {
      type: Array as PropType<string[]>,
      required: true
    },
    ruleSet: {
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
    const artifact = useRouteQuery("artifact")
    const fromAt = useRouteQuery("fromAt")
    const tagInput = useRouteQuery("tag", props.tag || null)
    const ruleId = useRouteQuery("ruleId")
    const toAt = useRouteQuery("toAt")

    const getSearchParams = (): AlertSearchParams => {
      const params: AlertSearchParams = {
        artifact: normalizeQuery(artifact.value),
        page: parseInt(props.page),
        ruleId: normalizeQuery(ruleId.value),
        tag: normalizeQuery(tagInput.value),
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
      artifact,
      fromAt,
      getSearchParams,
      ruleId,
      toAt,
      tagInput
    }
  }
})
</script>
