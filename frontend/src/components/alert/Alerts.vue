<template>
  <Alert
    v-for="(alert, index) in alerts.alerts"
    :alert="alert"
    :key="index"
    @refresh-page="refreshPage"
    @update-tag="updateTag"
  ></Alert>

  <Pagination
    :total="alerts.total"
    :currentPage="alerts.currentPage"
    :pageSize="alerts.pageSize"
    @update-page="updatePage"
  ></Pagination>
  <p class="help">
    ({{ alerts.total }} results in total, {{ alerts.alerts.length }} shown)
  </p>
</template>

<script lang="ts">
import { defineComponent, PropType } from "vue";

import Alert from "@/components/alert/Alert.vue";
import Pagination from "@/components/Pagination.vue";
import { Alerts } from "@/types";

export default defineComponent({
  name: "AlertsItem",
  components: {
    Alert,
    Pagination,
  },
  props: {
    alerts: {
      type: Object as PropType<Alerts>,
      required: true,
    },
  },
  emits: ["update-page", "refresh-page", "update-tag"],
  setup(_, context) {
    const scrollToTop = () => {
      window.scrollTo({
        top: 0,
      });
    };

    const updatePage = (page: number) => {
      scrollToTop();
      context.emit("update-page", page);
    };

    const refreshPage = () => {
      scrollToTop();
      context.emit("refresh-page");
    };

    const updateTag = (tag: string) => {
      scrollToTop();
      context.emit("update-tag", tag);
    };

    return { updatePage, updateTag, refreshPage };
  },
});
</script>
