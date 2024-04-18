<script setup lang="ts">
import Navbar from "@/components/NavbarItem.vue"
</script>

<template>
  <Navbar />
  <section class="section is-medium">
    <div class="container">
      <router-view />
    </div>
  </section>
</template>

<style>
table.is-fullwidth th {
  width: 120px;
}
</style>
