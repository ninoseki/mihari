<template>
  <article class="message is-warning" v-if="total === 0">
    <div class="message-body">There is no result to show.</div>
  </article>
  <nav class="pagination" role="navigation" aria-label="pagination" v-else>
    <ul class="pagination-list" v-if="hasOnlyOnePage">
      <li>
        <a class="pagination-link mt-2 is-current" @click="updatePage(1)">1</a>
      </li>
    </ul>
    <ul class="pagination-list" v-else>
      <li v-if="hasPreviousPage && isPreviousPageNotFirst">
        <a class="pagination-link mt-2" @click="updatePage(1)"> 1</a>
      </li>
      <li v-if="hasPreviousPage && isPreviousPageNotFirst">
        <span class="pagination-ellipsis">&hellip;</span>
      </li>
      <li v-if="hasPreviousPage">
        <a class="pagination-link mt-2" @click="updatePage(currentPage - 1)">
          {{ currentPage - 1 }}</a
        >
      </li>
      <li>
        <a class="pagination-link mt-2 is-current" @click="updatePage(currentPage)">
          {{ currentPage }}</a
        >
      </li>
      <li v-if="hasNextPage">
        <a class="pagination-link mt-2" @click="updatePage(currentPage + 1)">
          {{ currentPage + 1 }}</a
        >
      </li>
      <li v-if="hasNextPage && isNextPageNotLast">
        <span class="pagination-ellipsis">&hellip;</span>
      </li>
      <li v-if="hasNextPage && isNextPageNotLast">
        <a class="pagination-link mt-2" @click="updatePage(totalPageCount)">{{ totalPageCount }}</a>
      </li>
    </ul>
  </nav>
</template>

<script lang="ts">
import { computed, defineComponent } from "vue"

export default defineComponent({
  name: "AlertsPagination",
  props: {
    currentPage: {
      type: Number,
      required: true
    },
    pageSize: {
      type: Number,
      required: true
    },
    total: {
      type: Number,
      required: true
    }
  },
  emits: ["update-page"],
  setup(props, context) {
    const totalPageCount = computed(() => {
      return Math.ceil(props.total / props.pageSize)
    })

    const hasOnlyOnePage = computed(() => {
      return totalPageCount.value === 1
    })

    const hasPreviousPage = computed(() => {
      return props.currentPage > 1
    })

    const isPreviousPageNotFirst = computed(() => {
      return props.currentPage - 1 !== 1
    })

    const hasNextPage = computed(() => {
      return props.currentPage < totalPageCount.value
    })

    const isNextPageNotLast = computed(() => {
      return props.currentPage + 1 !== totalPageCount.value
    })

    const updatePage = (page: number) => {
      context.emit("update-page", page)
    }

    return {
      updatePage,
      hasNextPage,
      hasOnlyOnePage,
      hasPreviousPage,
      isNextPageNotLast,
      isPreviousPageNotFirst,
      totalPageCount
    }
  }
})
</script>
