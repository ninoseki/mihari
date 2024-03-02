import { BaseLink } from "@/links/base"
import type { LinkType, LinkTypeType } from "@/schemas"

export class DNSlyticsForIP extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()

    this.baseURL = "https://dnslytics.com"
    this.name = "DNSlytics"
    this.type = "ip"
  }

  public href(data: string): string {
    return this.baseURL + `/ip/${data}`
  }
}

export class DNSlyticsForDomain extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()

    this.baseURL = "https://dnslytics.com"
    this.name = "DNSlytics"
    this.type = "domain"
  }

  public href(data: string): string {
    return this.baseURL + `/domain/${data}`
  }
}
