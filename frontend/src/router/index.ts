import { createRouter, createWebHashHistory, type RouteRecordRaw } from "vue-router"

import Alert from "@/views/Alert.vue"
import Alerts from "@/views/Alerts.vue"
import Artifact from "@/views/Artifact.vue"
import Config from "@/views/Config.vue"
import EditRule from "@/views/EditRule.vue"
import NewRule from "@/views/NewRule.vue"
import Rule from "@/views/Rule.vue"
import Rules from "@/views/Rules.vue"

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
