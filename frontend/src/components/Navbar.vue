<template>
  <nav role="navigation" aria-label="main navigation" class="navbar is-fixed-top">
    <div class="navbar-brand">
      <a class="navbar-item"><h1 class="title">Mihari</h1></a>
    </div>
    <div class="navbar-menu">
      <div class="navbar-start">
        <router-link class="navbar-item" :to="{ name: 'Alerts' }">Alerts</router-link>
        <router-link class="navbar-item" :to="{ name: 'Artifacts' }">Artifacts</router-link>
        <router-link class="navbar-item" :to="{ name: 'Rules' }">Rules</router-link>
        <router-link class="navbar-item" :to="{ name: 'NewRule' }">New Rule</router-link>
        <router-link class="navbar-item" :to="{ name: 'Config' }">Config</router-link>
        <a class="navbar-item"
          ><a href="/redoc-static.html" target="_blank" class="navbar-item">API</a></a
        >
        <a class="navbar-item"
          ><a href="https://github.com/ninoseki/mihari" target="_blank" class="navbar-item"
            >GitHub</a
          ></a
        >
      </div>
      <div class="navbar-end">
        <div class="navbar-item">
          <span class="icon" @click="toggleDark()">
            <font-awesome-icon :icon="isDark ? 'moon' : 'sun'"></font-awesome-icon>
          </span>
        </div>
      </div>
    </div>
  </nav>
</template>

<script lang="ts">
import { useDark, useToggle } from "@vueuse/core"
import { defineComponent } from "vue"

export default defineComponent({
  name: "NavbarItem",
  setup() {
    const isDark = useDark({
      selector: "html",
      valueDark: "theme-dark",
      valueLight: "theme-light"
    })
    const toggleDark = useToggle(isDark)

    return { toggleDark, isDark }
  }
})
</script>

<style scoped>
.navbar {
  border-bottom: 1px solid lightgray;
}
</style>
