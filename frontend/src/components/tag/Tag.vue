<template>
  <div class="control" v-if="!isDeleted">
    <div
      class="tags has-addons are-medium"
      v-on:mouseover="showDeleteButton"
      v-on:mouseleave="hideDeleteButton"
    >
      <span class="tag is-info is-light" @click="updateTag">{{ tag.name }}</span>
      <a class="tag is-delete" v-if="isDeleteButtonEnabled" @click="deleteTag"></a>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, type PropType, ref } from "vue"

import { generateDeleteTagTask } from "@/api-helper"
import type { Tag } from "@/types"

export default defineComponent({
  name: "TagItem",
  props: {
    tag: {
      type: Object as PropType<Tag>,
      required: true
    }
  },
  setup(props, context) {
    const isDeleted = ref(false)
    const isDeleteButtonEnabled = ref(false)

    const deleteTagTask = generateDeleteTagTask()

    const deleteTag = async () => {
      const result = window.confirm(
        `Are you sure you want to delete ${props.tag.name} (ID: ${props.tag.id})?`
      )

      if (result) {
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

    const updateTag = () => {
      context.emit("update-tag", props.tag.name)
    }

    return {
      updateTag,
      isDeleted,
      deleteTag,
      showDeleteButton,
      hideDeleteButton,
      isDeleteButtonEnabled
    }
  }
})
</script>
