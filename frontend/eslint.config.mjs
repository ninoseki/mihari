// @ts-check
import pluginVitest from "@vitest/eslint-plugin"
import skipFormatting from "@vue/eslint-config-prettier/skip-formatting"
import { defineConfigWithVueTs, vueTsConfigs } from "@vue/eslint-config-typescript"
import simpleImportSort from "eslint-plugin-simple-import-sort"
import pluginVue from "eslint-plugin-vue"

const mode = process.env.NODE_ENV === "production" ? "error" : "warn"

export default defineConfigWithVueTs(
  {
    name: "app/files-to-lint",
    files: ["**/*.{ts,mts,tsx,vue}"]
  },
  {
    name: "app/files-to-ignore",
    ignores: ["**/dist/**", "**/dist-ssr/**", "**/coverage/**"]
  },
  pluginVue.configs["flat/essential"],
  vueTsConfigs.recommended,
  {
    ...pluginVitest.configs.recommended,
    files: ["src/**/__tests__/*"]
  },
  skipFormatting,
  {
    plugins: {
      "simple-import-sort": simpleImportSort
    },
    rules: {
      "simple-import-sort/imports": mode,
      "simple-import-sort/exports": mode,
      "no-console": mode,
      "no-debugger": mode
    }
  }
)
