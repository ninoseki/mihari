<script setup lang="ts">
import { onMounted } from "vue"

import { generateGetAlertsTask, generateGetArtifactsTask, generateGetRulesTask } from "@/api-helper"

const getAlertsTask = generateGetAlertsTask()
const getRulesTask = generateGetRulesTask()
const getArtifactsTask = generateGetArtifactsTask()

onMounted(() => {
  getAlertsTask.perform({ q: "", page: 1, limit: 0 })
  getRulesTask.perform({ q: "", page: 1, limit: 0 })
  getArtifactsTask.perform({ q: "", page: 1, limit: 0 })
})
</script>

<template>
  <div class="columns">
    <div class="column is-one-third">
      <div class="card">
        <div class="card-content">
          <div class="level is-mobile">
            <div class="level-item">
              <div>
                <h3 class="subtitle is-spaced">Rules</h3>
                <h1 class="title">
                  {{ getRulesTask.last?.value?.total ?? "N/A" }}
                </h1>
              </div>
            </div>
            <div class="level-item">
              <span class="icon">
                <font-awesome-icon icon="file" size="2x" />
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="column is-one-third">
      <div class="card">
        <div class="card-content">
          <div class="level is-mobile">
            <div class="level-item">
              <div>
                <h3 class="subtitle is-spaced">Alerts</h3>
                <h1 class="title">
                  {{ getAlertsTask.last?.value?.total ?? "N/A" }}
                </h1>
              </div>
            </div>
            <div class="level-item">
              <span class="icon">
                <font-awesome-icon icon="bell" size="2x" />
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="column is-one-third">
      <div class="card">
        <div class="card-content">
          <div class="level is-mobile">
            <div class="level-item">
              <div>
                <h3 class="subtitle is-spaced">Artifacts</h3>
                <h1 class="title">
                  {{ getArtifactsTask.last?.value?.total ?? "N/A" }}
                </h1>
              </div>
            </div>
            <div class="level-item">
              <span class="icon">
                <font-awesome-icon icon="ticket" size="2x" />
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
