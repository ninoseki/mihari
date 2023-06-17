<template>
  <Navbar></Navbar>
  <section class="section is-medium">
    <div class="container">
      <router-view />
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent } from "vue";

import Navbar from "@/components/Navbar.vue";

export default defineComponent({
  name: "App",
  components: {
    Navbar,
  },
});
</script>

<style>
table.is-fullwidth th {
  width: 120px;
}
</style>
