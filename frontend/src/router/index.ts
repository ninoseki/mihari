import { createRouter, createWebHashHistory, RouteRecordRaw } from "vue-router";

import Alerts from "@/views/Alerts.vue";
import Artifact from "@/views/Artifact.vue";
import Configs from "@/views/Configs.vue";
import EditRule from "@/views/EditRule.vue";
import NewRule from "@/views/NewRule.vue";
import Rule from "@/views/Rule.vue";
import Rules from "@/views/Rules.vue";

const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "Alerts",
    component: Alerts,
  },
  {
    path: "/configs",
    name: "Configs",
    component: Configs,
  },
  {
    path: "/artifacts/:id",
    name: "Artifact",
    component: Artifact,
    props: true,
  },
  {
    path: "/rules",
    name: "Rules",
    component: Rules,
  },
  {
    path: "/rules/new",
    name: "NewRule",
    component: NewRule,
  },
  {
    path: "/rules/:id",
    name: "Rule",
    component: Rule,
    props: true,
  },
  {
    path: "/rules/:id/edit",
    name: "EditRule",
    component: EditRule,
    props: true,
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
