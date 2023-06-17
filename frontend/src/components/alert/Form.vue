<template>
  <div class="columns">
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Rule</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <div class="select">
                <select v-model="ruleId">
                  <option></option>
                  <option v-for="ruleId_ in ruleSet" :key="ruleId_">
                    {{ ruleId_ }}
                  </option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="column">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Artifact</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="text" v-model="artifact" />
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

import { AlertSearchParams } from "@/types";
import { normalizeQueryParam } from "@/utils";

export default defineComponent({
  name: "AlertsForm",
  props: {
    tags: {
      type: Array as PropType<string[]>,
      required: true,
    },
    ruleSet: {
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

    const artifact = ref<string | undefined>(undefined);
    const fromAt = ref<string | undefined>(undefined);
    const tagInput = ref<string | undefined>(props.tag);
    const ruleId = ref<string | undefined>(undefined);
    const toAt = ref<string | undefined>(undefined);
    const asn = ref<number | undefined>(undefined);
    const dnsRecord = ref<string | undefined>(undefined);
    const reverseDnsName = ref<string | undefined>(undefined);

    const updateByQueryParams = () => {
      const asn_ = route.query["asn"];
      const normalizedAsn = normalizeQueryParam(asn_);
      asn.value =
        normalizedAsn === undefined ? undefined : parseInt(normalizedAsn);

      const dnsRecord_ = route.query["dnsRecord"];
      dnsRecord.value = normalizeQueryParam(dnsRecord_);

      const reverseDnsName_ = route.query["reverseDnsName"];
      reverseDnsName.value = normalizeQueryParam(reverseDnsName_);

      const tag_ = route.query["tag"];
      if (tagInput.value === undefined) {
        tagInput.value = normalizeQueryParam(tag_);
      }
    };

    const getSearchParams = (): AlertSearchParams => {
      updateByQueryParams();

      const params: AlertSearchParams = {
        artifact: artifact.value === "" ? undefined : artifact.value,
        page: props.page,
        ruleId: ruleId.value === "" ? undefined : ruleId.value,
        tag: tagInput.value === "" ? undefined : tagInput.value,
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
      artifact,
      fromAt,
      getSearchParams,
      ruleId,
      toAt,
      tagInput,
    };
  },
});
</script>
