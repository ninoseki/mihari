<template>
  <pre
    ref="pre"
    class="line-numbers"
  ><code class="language-yaml">{{ yaml }}</code></pre>
</template>

<script lang="ts">
// eslint-disable-next-line simple-import-sort/imports
import { defineComponent, onMounted, ref } from "vue";

import Prism from "prismjs";

import "prismjs/components/prism-yaml";
import "prismjs/plugins/custom-class/prism-custom-class";
import "prismjs/plugins/line-numbers/prism-line-numbers.css";
import "prismjs/plugins/line-numbers/prism-line-numbers";
import "prismjs/themes/prism-twilight.css";

export default defineComponent({
  name: "YAML",
  props: {
    yaml: {
      type: String,
      required: true,
    },
  },
  setup() {
    const pre = ref<HTMLElement | undefined>(undefined);

    Prism.plugins.customClass.map({
      number: "prism-number",
      tag: "prism-tag",
    });

    onMounted(() => {
      if (pre.value) {
        pre.value.querySelectorAll("code").forEach((elem) => {
          Prism.highlightElement(elem);
        });
      }
    });

    return { pre };
  },
});
</script>
