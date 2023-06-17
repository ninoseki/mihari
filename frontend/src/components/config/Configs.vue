<template>
  <div class="box">
    <div class="table-container">
      <table class="table is-fullwidth">
        <thead>
          <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Configured</th>
            <th>Key-value(s)</th>
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
              <button
                class="button is-success is-small ml-1"
                v-if="config.isConfigured"
              >
                <span class="icon is-small">
                  <i class="fas fa-check"></i>
                </span>
                <span>Yes</span>
              </button>
              <button class="button is-warning is-small ml-1" v-else>
                <span class="icon is-small">
                  <i class="fas fa-exclamation"></i>
                </span>
                <span>No</span>
              </button>
            </td>
            <td>
              <ul>
                <li v-for="(kv, index) in config.values" :key="index">
                  <strong> {{ kv.key }} </strong>:
                  <code v-if="kv.value">{{ kv.value }}</code>
                  <span v-else>N/A</span>
                </li>
              </ul>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";

import { Config } from "@/types";

export default defineComponent({
  name: "ConfigsItem",
  props: {
    configs: {
      type: Array as PropType<Config[]>,
      required: true,
    },
  },
});
</script>
