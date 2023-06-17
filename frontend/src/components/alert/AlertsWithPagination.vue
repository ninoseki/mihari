<template>
  <Loading v-if="getAlertsTask.isRunning"></Loading>

  <Alerts
    :alerts="getAlertsTask.last.value"
    v-if="getAlertsTask.last?.value"
    @refresh-page="refreshPage"
    @update-page="updatePage"
    @update-tag="updateTag"
  >
  </Alerts>
</template>

<script lang="ts">
import { defineComponent, nextTick, onMounted, ref, watch } from "vue";

import { generateGetAlertsTask } from "@/api-helper";
import Alerts from "@/components/alert/Alerts.vue";
import Loading from "@/components/Loading.vue";
import { AlertSearchParams } from "@/types";

export default defineComponent({
  name: "AlertsWithPagination",
  props: {
    ruleId: {
      type: String,
    },
    artifact: {
      type: String,
    },
  },
  components: {
    Alerts,
    Loading,
  },
  setup(props) {
    const page = ref(1);
    const tag = ref<string | undefined>(undefined);

    const getAlertsTask = generateGetAlertsTask();

    const getAlerts = async () => {
      const params: AlertSearchParams = {
        artifact: props.artifact,
        page: page.value,
        ruleId: props.ruleId,
        tag: tag.value,
        toAt: undefined,
        fromAt: undefined,
      };
      return await getAlertsTask.perform(params);
    };

    const updatePage = (newPage: number) => {
      page.value = newPage;
    };

    const resetPage = () => {
      page.value = 1;
    };

    const refreshPage = async () => {
      resetPage();
      await getAlerts();
    };

    const updateTag = (newTag: string | undefined) => {
      if (tag.value === newTag) {
        tag.value = undefined;
      } else {
        tag.value = newTag;
      }
    };

    onMounted(async () => {
      await getAlerts();
    });

    watch([props, page, tag], async () => {
      nextTick(async () => await getAlerts());
    });

    return {
      getAlertsTask,
      refreshPage,
      updatePage,
      updateTag,
    };
  },
});
</script>
