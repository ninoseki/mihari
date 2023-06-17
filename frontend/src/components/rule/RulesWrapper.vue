<template>
  <div class="box mb-6">
    <FormComponent
      ref="form"
      :tags="getTagsTask.last?.value || []"
      :page="page"
      :tag="tag"
    ></FormComponent>

    <hr />

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

  <div v-if="getRulesTask.performCount > 0">
    <hr />

    <Loading v-if="getRulesTask.isRunning"></Loading>

    <ErrorMessage
      v-if="getRulesTask.isError"
      :error="getRulesTask.last?.error"
    ></ErrorMessage>

    <Rules
      :rules="getRulesTask.last.value"
      v-if="getRulesTask.last?.value"
      @refresh-page="refreshPage"
      @update-page="updatePage"
      @update-tag="updateTag"
    ></Rules>
  </div>
</template>

<script lang="ts">
import { defineComponent, nextTick, onMounted, ref, watch } from "vue";

import { generateGetRulesTask, generateGetTagsTask } from "@/api-helper";
import ErrorMessage from "@/components/ErrorMessage.vue";
import Loading from "@/components/Loading.vue";
import FormComponent from "@/components/rule/Form.vue";
import Rules from "@/components/rule/Rules.vue";
import { RuleSearchParams } from "@/types";

export default defineComponent({
  name: "RulesWrapper",
  components: {
    Rules,
    Loading,
    FormComponent,
    ErrorMessage,
  },
  setup() {
    const page = ref(1);
    const tag = ref<string | undefined>(undefined);
    const form = ref<InstanceType<typeof FormComponent>>();

    const getRulesTask = generateGetRulesTask();
    const getTagsTask = generateGetTagsTask();

    const getRules = async () => {
      const params = form.value?.getSearchParams() as RuleSearchParams;
      return await getRulesTask.perform(params);
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

      await getRules();
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
      // this function will be invoked when a rule is deleted
      await search();
    };

    onMounted(async () => {
      getTagsTask.perform();
      await getRules();
    });

    watch([page, tag], async () => {
      nextTick(async () => await getRules());
    });

    return {
      form,
      getRulesTask,
      getTagsTask,
      page,
      tag,
      refreshPage,
      search,
      updatePage,
      updateTag,
    };
  },
});
</script>
