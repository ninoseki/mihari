import "bulma/css/bulma.css"
import "bulma-helpers/css/bulma-helpers.min.css"
import "font-awesome-animation/css/font-awesome-animation.min.css"

import { library } from "@fortawesome/fontawesome-svg-core"
import {
  faArrowRight,
  faBarcode,
  faBell,
  faCheck,
  faEdit,
  faExclamation,
  faFile,
  faInfoCircle,
  faLightbulb,
  faMagnifyingGlass,
  faMoon,
  faPlus,
  faQuestion,
  faSearch,
  faSpinner,
  faSun,
  faTicket,
  faTimes,
  faTriangleExclamation
} from "@fortawesome/free-solid-svg-icons"
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome"
import { createApp } from "vue"

import App from "@/App.vue"
import router from "@/router"

library.add(
  faArrowRight,
  faBarcode,
  faCheck,
  faEdit,
  faExclamation,
  faInfoCircle,
  faLightbulb,
  faPlus,
  faSearch,
  faSpinner,
  faTimes,
  faQuestion,
  faMagnifyingGlass,
  faFile,
  faBell,
  faTicket,
  faTriangleExclamation,
  faMoon,
  faSun
)

const app = createApp(App)

app.component("font-awesome-icon", FontAwesomeIcon)

app.use(router).mount("#app")
