<template>
  <div class="columns">
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Title</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="text" v-model="title" />
            </p>
          </div>
        </div>
      </div>
    </div>
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Description</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="text" v-model="description" />
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="columns">
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Tag</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <div class="select">
                <select v-model="tagInput">
                  <option></option>
                  <option v-for="tag_ in tags" :key="tag_">
                    {{ tag_ }}
                  </option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="column"></div>
  </div>

  <div class="columns">
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">From</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="date" v-model="fromAt" />
            </p>
          </div>
        </div>
      </div>
    </div>
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">To</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="date" v-model="toAt" />
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType, ref, watch } from "vue";
import { useRoute } from "vue-router";

import { RuleSearchParams } from "@/types";
import { normalizeQueryParam } from "@/utils";

export default defineComponent({
  name: "RulesForm",
  props: {
    tags: {
      type: Array as PropType<string[]>,
      required: true,
    },
    page: {
      type: Number,
      required: true,
    },
    tag: {
      type: String,
      required: false,
    },
  },
  setup(props) {
    const route = useRoute();

    const description = ref<string | undefined>(undefined);
    const fromAt = ref<string | undefined>(undefined);
    const tagInput = ref<string | undefined>(props.tag);
    const title = ref<string | undefined>(undefined);
    const toAt = ref<string | undefined>(undefined);

    const updateByQueryParams = () => {
      const tag_ = route.query["tag"];
      if (tagInput.value === undefined) {
        tagInput.value = normalizeQueryParam(tag_);
      }
    };

    const getSearchParams = (): RuleSearchParams => {
      updateByQueryParams();

      const params: RuleSearchParams = {
        description: description.value === "" ? undefined : description.value,
        page: props.page,
        tag: tagInput.value === "" ? undefined : tagInput.value,
        title: title.value === "" ? undefined : title.value,
        toAt: toAt.value === "" ? undefined : toAt.value,
        fromAt: fromAt.value === "" ? undefined : fromAt.value,
      };
      return params;
    };

    watch(
      () => props.tag,
      () => {
        tagInput.value = props.tag;
      }
    );

    return {
      description,
      fromAt,
      getSearchParams,
      title,
      toAt,
      tagInput,
    };
  },
});
</script>
