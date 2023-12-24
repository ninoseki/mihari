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
          <tr v-for="config in configs" :key="config.name">
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
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType } from "vue"

import type { Config } from "@/types"

export default defineComponent({
  name: "ConfigsItem",
  props: {
    configs: {
      type: Array as PropType<Config[]>,
      required: true
    }
  }
})
</script>
