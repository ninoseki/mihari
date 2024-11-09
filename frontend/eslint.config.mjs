// @ts-check
import pluginVitest from "@vitest/eslint-plugin"
import skipFormatting from "@vue/eslint-config-prettier/skip-formatting"
import vueTsEslintConfig from "@vue/eslint-config-typescript"
import simpleImportSort from "eslint-plugin-simple-import-sort"
import pluginVue from "eslint-plugin-vue"
import tseslint from "typescript-eslint"

const mode = process.env.NODE_ENV === "production" ? "error" : "warn"

export default tseslint.config(
  {
    name: "app/files-to-lint",
    files: ["**/*.{ts,mts,tsx,vue}"]
  },
  {
    name: "app/files-to-ignore",
    ignores: ["**/dist/**", "**/dist-ssr/**", "**/coverage/**"]
  },
  ...pluginVue.configs["flat/essential"],
  ...vueTsEslintConfig(),
  {
    ...pluginVitest.configs.recommended,
    files: ["src/**/__tests__/*"]
  },
  // @ts-expect-error there is not type definition
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
