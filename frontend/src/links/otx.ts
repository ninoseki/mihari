import { BaseLink } from "@/links/base"
import type { LinkType, LinkTypeType } from "@/schemas"

export class OtxForIP extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()

    this.baseURL = "https://otx.alienvault.com"
    this.name = "OTX"
    this.type = "ip"
  }

  public href(data: string): string {
    return this.baseURL + `/indicator/ip/${data}`
  }
}

export class OtxForDomain extends OtxForIP implements LinkType {
  public type: LinkTypeType

  public constructor() {
    super()
    this.type = "domain"
  }

  public href(data: string): string {
    return this.baseURL + `/indicator/domain/${data}`
  }
}
