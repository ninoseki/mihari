<template>
  <div class="control" v-if="!isDeleted">
    <div
      class="tags has-addons are-medium"
      v-on:mouseover="showDeleteButton"
      v-on:mouseleave="hideDeleteButton"
    >
      <router-link
        class="tag is-info is-light"
        :to="{ name: navigateTo, query: { q: getQuery(tag.name) } }"
        >{{ tag.name }}</router-link
      >
      <a class="tag is-delete" v-if="isDeleteButtonEnabled && deletable" @click="deleteTag"></a>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType, ref } from "vue"

import { generateDeleteTagTask } from "@/api-helper"
import type { NavigateToType, TagType } from "@/schemas"

export default defineComponent({
  name: "TagItem",
  props: {
    tag: {
      type: Object as PropType<TagType>,
      required: true
    },
    deletable: {
      type: Boolean,
      default: false
    },
    navigateTo: {
      type: String as PropType<NavigateToType>,
      required: true
    }
  },
  setup(props) {
    const isDeleted = ref(false)
    const isDeleteButtonEnabled = ref(false)

    const deleteTagTask = generateDeleteTagTask()

    const deleteTag = async () => {
      const confirmed = window.confirm(
        `Are you sure you want to delete ${props.tag.name} (ID: ${props.tag.id})?`
      )

      if (confirmed) {
        await deleteTagTask.perform(props.tag.id)
        isDeleted.value = true
      }
    }

    const showDeleteButton = () => {
      isDeleteButtonEnabled.value = true
    }

    const hideDeleteButton = () => {
      isDeleteButtonEnabled.value = false
    }

    const getQuery = (name: string) => {
      return `tag:"${name}"`
    }

    return {
      isDeleted,
      deleteTag,
      showDeleteButton,
      hideDeleteButton,
      isDeleteButtonEnabled,
      getQuery
    }
  }
})
</script>
