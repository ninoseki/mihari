import ace from "ace-builds"
import modeYamlUrl from "ace-builds/src-min-noconflict/mode-yaml?url"
import themeMonokaiUrl from "ace-builds/src-min-noconflict/theme-monokai?url"

ace.config.setModuleUrl("ace/mode/yaml", modeYamlUrl)
ace.config.setModuleUrl("ace/theme/monokai", themeMonokaiUrl)
