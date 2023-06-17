<template>
  <div v-if="hasRules">
    <table class="table is-fullwidth">
      <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Description</th>
        <th>Tags</th>
      </tr>
      <tr v-for="rule in rules.rules" :key="rule.id">
        <td>
          <router-link :to="{ name: 'Rule', params: { id: rule.id } }">{{
            rule.id
          }}</router-link>
        </td>
        <td>
          {{ rule.title }}
        </td>
        <td>
          {{ rule.description }}
        </td>
        <td>
          <Tags :tags="rule.tags" @update-tag="updateTag"></Tags>
        </td>
      </tr>
    </table>
  </div>
  <Pagination
    :currentPage="rules.currentPage"
    :total="rules.total"
    :pageSize="rules.pageSize"
    @update-page="updatePage"
  ></Pagination>
  <p class="help">
    ({{ rules.total }} results in total, {{ rules.rules.length }} shown)
  </p>
</template>

<script lang="ts">
import { computed, defineComponent, PropType } from "vue";

import Pagination from "@/components/Pagination.vue";
import Tags from "@/components/tag/Tags.vue";
import { Rules } from "@/types";

export default defineComponent({
  name: "RulesItem",
  props: {
    rules: {
      type: Object as PropType<Rules>,
      required: true,
    },
  },
  components: {
    Pagination,
    Tags,
  },
  emits: ["update-page", "refresh-page", "update-tag"],
  setup(props, context) {
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

    const hasRules = computed(() => {
      return props.rules.rules.length > 0;
    });

    return { updatePage, refreshPage, updateTag, hasRules };
  },
});
</script>
