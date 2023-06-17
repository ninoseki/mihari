<template>
  <nav
    role="navigation"
    aria-label="main navigation"
    class="navbar is-fixed-top"
  >
    <div class="navbar-brand">
      <a class="navbar-item"><h1 class="title">Mihari</h1></a
      ><a role="button" aria-label="menu" class="navbar-burger burger"
        ><span aria-hidden="true"></span><span aria-hidden="true"></span
        ><span aria-hidden="true"></span
      ></a>
    </div>
    <div class="navbar-menu">
      <div class="navbar-start"></div>
      <div class="navbar-end">
        <router-link class="navbar-item" :to="{ name: 'Alerts' }"
          >Alerts</router-link
        >
        <router-link class="navbar-item" :to="{ name: 'NewRule' }"
          >New rule</router-link
        >
        <router-link class="navbar-item" :to="{ name: 'Rules' }"
          >Rules</router-link
        >
        <router-link class="navbar-item" :to="{ name: 'Configs' }"
          >Configs</router-link
        >
        <a class="navbar-item"
          ><a href="/redoc-static.html" target="_blank" class="navbar-item"
            >API</a
          ></a
        >
        <a class="navbar-item"
          ><a
            href="https://github.com/ninoseki/mihari"
            target="_blank"
            class="navbar-item"
            >GitHub</a
          ></a
        >
      </div>
    </div>
  </nav>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  name: "NavbarItem",
});
</script>

<style scoped>
.navbar {
  border-bottom: 1px solid lightgray;
}
</style>
