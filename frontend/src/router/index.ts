import { createRouter, createWebHashHistory, type RouteRecordRaw } from "vue-router"

import Alerts from "@/views/AlertsView.vue"
import Alert from "@/views/AlertView.vue"
import Artifacts from "@/views/ArtifactsView.vue"
import Artifact from "@/views/ArtifactView.vue"
import Config from "@/views/ConfigView.vue"
import EditRule from "@/views/EditRule.vue"
import NewRule from "@/views/NewRule.vue"
import Rules from "@/views/RulesView.vue"
import Rule from "@/views/RuleView.vue"

const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "Alerts",
    component: Alerts
  },
  {
    path: "/alerts/:id",
    name: "Alert",
    component: Alert,
    props: true
  },
  {
    path: "/config",
    name: "Config",
    component: Config
  },
  {
    path: "/artifacts/",
    name: "Artifacts",
    component: Artifacts
  },
  {
    path: "/artifacts/:id",
    name: "Artifact",
    component: Artifact,
    props: true
  },
  {
    path: "/rules",
    name: "Rules",
    component: Rules
  },
  {
    path: "/rules/new",
    name: "NewRule",
    component: NewRule
  },
  {
    path: "/rules/:id",
    name: "Rule",
    component: Rule,
    props: true
  },
  {
    path: "/rules/:id/edit",
    name: "EditRule",
    component: EditRule,
    props: true
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
