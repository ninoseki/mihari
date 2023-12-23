<template>
  <Loading v-if="getAlertTask.isRunning"></Loading>
  <ErrorMessage v-if="getAlertTask.isError" :error="getAlertTask.last?.error"></ErrorMessage>
  <AlertComponent
    :alert="getAlertTask.last.value"
    @delete="onDelete"
    v-if="getAlertTask.last?.value"
  ></AlertComponent>
</template>

<script lang="ts">
import { defineComponent, onMounted } from "vue"
import { useRouter } from "vue-router"

import { generateGetAlertTask } from "@/api-helper"
import AlertComponent from "@/components/alert/AlertDetail.vue"
import ErrorMessage from "@/components/ErrorMessage.vue"
import Loading from "@/components/Loading.vue"

export default defineComponent({
  name: "AlertDetailWrapper",
  components: {
    AlertComponent,
    Loading,
    ErrorMessage
  },
  props: {
    id: {
      type: Number,
      required: true
    }
  },
  setup(props) {
    const router = useRouter()
    const getAlertTask = generateGetAlertTask()

    const onDelete = () => {
      router.push("/")
    }

    onMounted(async () => {
      await getAlertTask.perform(props.id)
    })

    return {
      getAlertTask,
      onDelete
    }
  }
})
</script>
