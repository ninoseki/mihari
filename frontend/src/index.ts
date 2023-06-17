import { Link } from "@/types";

import { Censys } from "./links/censys";
import { Crtsh } from "./links/crtsh";
import {
  SecurityTrailsForDomain,
  SecurityTrailsForIP,
} from "./links/securitytrails";
import { Shodan } from "./links/shodan";
import { UrlscanForDomain, UrlscanForIP } from "./links/urlscan";
import { VirusTotalForDomain, VirusTotalForIP } from "./links/virustotal";

export const Links: Link[] = [
  new Censys(),
  new Crtsh(),
  new SecurityTrailsForDomain(),
  new SecurityTrailsForIP(),
  new Shodan(),
  new UrlscanForDomain(),
  new UrlscanForIP(),
  new VirusTotalForDomain(),
  new VirusTotalForIP(),
];
