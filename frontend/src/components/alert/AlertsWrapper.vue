<template>
  <div class="box mb-6">
    <FormComponent
      ref="form"
      :ruleSet="getRuleSetTask.last?.value || []"
      :tags="getTagsTask.last?.value || []"
      :page="page"
      :tag="tag"
    ></FormComponent>

    <hr />

    <div class="columns">
      <div class="column">
        <div class="field is-grouped is-grouped-centered">
          <p class="control">
            <a class="button is-primary" @click="search">
              <span class="icon is-small">
                <i class="fas fa-search"></i>
              </span>
              <span>Search</span>
            </a>
          </p>
        </div>
      </div>
    </div>
  </div>

  <div v-if="getAlertsTask.performCount > 0">
    <hr />

    <Loading v-if="getAlertsTask.isRunning"></Loading>

    <ErrorMessage
      v-if="getAlertsTask.isError"
      :error="getAlertsTask.last?.error"
    ></ErrorMessage>

    <AlertsComponent
      :alerts="getAlertsTask.last.value"
      v-if="getAlertsTask.last?.value"
      @refresh-page="refreshPage"
      @update-page="updatePage"
      @update-tag="updateTag"
    ></AlertsComponent>
  </div>
</template>

<script lang="ts">
import { defineComponent, nextTick, onMounted, ref, watch } from "vue";

import {
  generateGetAlertsTask,
  generateGetRuleSetTask,
  generateGetTagsTask,
} from "@/api-helper";
import AlertsComponent from "@/components/alert/Alerts.vue";
import FormComponent from "@/components/alert/Form.vue";
import ErrorMessage from "@/components/ErrorMessage.vue";
import Loading from "@/components/Loading.vue";
import { AlertSearchParams } from "@/types";

export default defineComponent({
  name: "AlertsWrapper",
  components: {
    AlertsComponent,
    FormComponent,
    Loading,
    ErrorMessage,
  },
  setup() {
    const page = ref(1);
    const tag = ref<string | undefined>(undefined);
    const form = ref<InstanceType<typeof FormComponent>>();

    const getAlertsTask = generateGetAlertsTask();
    const getTagsTask = generateGetTagsTask();
    const getRuleSetTask = generateGetRuleSetTask();

    const getAlerts = async () => {
      const params = form.value?.getSearchParams() as AlertSearchParams;
      return await getAlertsTask.perform(params);
    };

    const updatePage = (newPage: number) => {
      page.value = newPage;
    };

    const resetPage = () => {
      page.value = 1;
    };

    const search = async () => {
      // reset page
      resetPage();

      await getAlerts();
    };

    const updateTag = (newTag: string | undefined) => {
      if (tag.value === newTag) {
        tag.value = undefined;
      } else {
        tag.value = newTag;
      }

      nextTick(async () => await search());
    };

    const refreshPage = async () => {
      // it is just an alias of search
      // this function will be invoked when an alert is deleted
      await search();
    };

    onMounted(async () => {
      getTagsTask.perform();
      getRuleSetTask.perform();

      await getAlerts();
    });

    watch([page, tag], async () => {
      nextTick(async () => await getAlerts());
    });

    return {
      getAlertsTask,
      getRuleSetTask,
      getTagsTask,
      refreshPage,
      search,
      tag,
      updatePage,
      updateTag,
      form,
      page,
    };
  },
});
</script>
