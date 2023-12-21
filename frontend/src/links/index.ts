import type { Link } from "@/types"

import { AnyRun } from "./anyrun"
import { Censys } from "./censys"
import { Crtsh } from "./crtsh"
import { DNSlyticsForDomain, DNSlyticsForIP } from "./dnslytics"
import { EmailRep } from "./emailrep"
import { GreyNoise } from "./greynoise"
import { Intezer } from "./intezer"
import { OtxForDomain, OtxForIP } from "./otx"
import { SecurityTrailsForDomain, SecurityTrailsForIP } from "./securitytrails"
import { Shodan } from "./shodan"
import { UrlscanForDomain, UrlscanForIP, UrlscanForURL } from "./urlscan"
import {
  VirusTotalForDomain,
  VirusTotalForHash,
  VirusTotalForIP,
  VirusTotalForURL
} from "./virustotal"

export const Links: Link[] = [
  new AnyRun(),
  new Censys(),
  new Crtsh(),
  new DNSlyticsForDomain(),
  new DNSlyticsForIP(),
  new EmailRep(),
  new GreyNoise(),
  new Intezer(),
  new OtxForDomain(),
  new OtxForIP(),
  new SecurityTrailsForDomain(),
  new SecurityTrailsForIP(),
  new Shodan(),
  new UrlscanForDomain(),
  new UrlscanForIP(),
  new UrlscanForURL(),
  new VirusTotalForDomain(),
  new VirusTotalForHash(),
  new VirusTotalForIP(),
  new VirusTotalForURL()
]
