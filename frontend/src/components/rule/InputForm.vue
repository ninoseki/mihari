<template>
  <div class="block my-editor-wrapper" ref="wrapper">
    <PrismEditor
      class="my-editor"
      v-model="yamlInput"
      :highlight="highlighter"
      line-numbers
    ></PrismEditor>
  </div>
</template>

<script lang="ts">
// eslint-disable-next-line simple-import-sort/imports
import "vue-prism-editor/dist/prismeditor.min.css";

import { defineComponent, ref, watchEffect } from "vue";
import { PrismEditor } from "vue-prism-editor";

import Prism from "prismjs";

import "prismjs/components/prism-yaml";
import "prismjs/plugins/custom-class/prism-custom-class";
import "prismjs/themes/prism-twilight.css";

export default defineComponent({
  name: "RuleInputForm",
  components: {
    PrismEditor,
  },
  props: {
    yaml: {
      type: String,
      required: true,
    },
  },
  emits: ["update-yaml"],
  setup(props, context) {
    const yamlInput = ref(props.yaml);
    const wrapper = ref<HTMLElement | undefined>(undefined);

    Prism.plugins.customClass.map({
      number: "prism-number",
      tag: "prism-tag",
    });

    const highlighter = (code: string) => {
      return Prism.highlight(code, Prism.languages.yaml, "yaml");
    };

    watchEffect(() => {
      context.emit("update-yaml", yamlInput.value);

      // TODO: a dirty hack to change the default text color
      if (wrapper.value) {
        const strings = wrapper.value.querySelectorAll(":not(span.token)");
        strings.forEach((string) => {
          (string as HTMLElement).style.color = "white";
        });
      }
    });

    return { yamlInput, highlighter, wrapper };
  },
});
</script>

<style scoped>
.my-editor {
  background: hsl(0, 0%, 8%);
  font-family: Fira code, Fira Mono, Consolas, Menlo, Courier, monospace;
  font-size: 1em;
  line-height: 1.5;
  padding: 5px;
}

.my-editor-wrapper {
  background: hsl(0, 0%, 8%);
  padding: 10px;
}
</style>
