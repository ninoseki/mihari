<script setup lang="ts">
import { type PropType } from "vue"

import type { ConfigsType } from "@/schemas"

type ConfigEntry = ConfigsType["results"][number]

const CENSYS_KEY = "censys"
const CENSYS_LEGACY_KEYS = ["CENSYS_ID", "CENSYS_SECRET"] as const
const CENSYS_PLATFORM_PRIMARY_KEYS = ["CENSYS_V3_API_KEY", "CENSYS_V3_ORG_ID"] as const

const props = defineProps({
  configs: {
    type: Object as PropType<ConfigsType>,
    required: true
  }
})

function isCensys(config: ConfigEntry): boolean {
  return config.name === CENSYS_KEY
}

function getItemValue(config: ConfigEntry, envKey: string): string | null {
  return config.items?.find(item => item.key === envKey)?.value ?? null
}

function itemsByKeys(config: ConfigEntry, keys: readonly string[]) {
  return keys.map(key => ({
    key,
    value: getItemValue(config, key)
  }))
}

const configs = props.configs
</script>

<template>
  <div class="box">
    <div class="table-container">
      <table class="table is-fullwidth">
        <thead>
          <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Configured?</th>
            <th>Items</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="config in configs.results" :key="config.name">
            <td>
              {{ config.name }}
            </td>
            <td>
              {{ config.type }}
            </td>
            <td>
              <button class="button is-success is-small ml-1" v-if="config.configured">
                <span class="icon is-small">
                  <font-awesome-icon icon="check"></font-awesome-icon>
                </span>
                <span>Yes</span>
              </button>
              <button class="button is-warning is-small ml-1" v-else>
                <span class="icon is-small">
                  <font-awesome-icon icon="exclamation"></font-awesome-icon>
                </span>
                <span>No</span>
              </button>
            </td>
            <td>
              <template v-if="isCensys(config)">
                <div class="columns is-variable is-4">
                  <div class="column">
                    <p class="is-size-7 has-text-weight-semibold mb-1">Version 2</p>
                    <div class="field is-grouped is-grouped-multiline">
                      <div class="control" v-for="item in itemsByKeys(config, CENSYS_LEGACY_KEYS)" :key="item.key">
                        <div class="tags has-addons">
                          <span class="tag is-dark"> {{ item.key }}</span>
                          <span class="tag" :class="{ 'is-success': item.value, 'is-warning': !item.value }">
                            {{ item.value || "N/A" }}
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="column">
                    <p class="is-size-7 has-text-weight-semibold mb-1">Version 3</p>
                    <div class="field is-grouped is-grouped-multiline">
                      <div class="control" v-for="item in itemsByKeys(config, CENSYS_PLATFORM_PRIMARY_KEYS)" :key="item.key">
                        <div class="tags has-addons">
                          <span class="tag is-dark"> {{ item.key }}</span>
                          <span class="tag" :class="{ 'is-success': item.value, 'is-warning': !item.value }">
                            {{ item.value || "N/A" }}
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </template>
              <template v-else>
                <div class="field is-grouped is-grouped-multiline">
                  <div class="control" v-for="(item, index) in config.items" :key="index">
                    <div class="tags has-addons">
                      <span class="tag is-dark"> {{ item.key }}</span>
                      <span
                        class="tag"
                        :class="{ 'is-success': item.value, 'is-warning': !item.value }"
                      >
                        {{ item.value || "N/A" }}</span
                      >
                    </div>
                  </div>
                </div>
              </template>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
