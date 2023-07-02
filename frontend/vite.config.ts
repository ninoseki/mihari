import { fileURLToPath, URL } from "node:url"

import vue from "@vitejs/plugin-vue"
import { defineConfig } from "vite"

const env = process.env
const target = env.BACKEND_URL || "http://localhost:9292/"
const port = parseInt(env.port || "8080")

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    port,
    proxy: {
      "/api": target
    }
  },
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url))
    }
  }
})
