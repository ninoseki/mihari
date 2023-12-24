import { fileURLToPath, URL } from "node:url"

import vue from "@vitejs/plugin-vue"
import { defineConfig } from "vite"

const env = process.env
const target = env.BACKEND_URL || "http://localhost:9292/"

export default defineConfig({
  plugins: [vue()],
  server: {
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
