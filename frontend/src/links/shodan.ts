import { BaseLink } from "@/links/base"
import type { LinkType, LinkTypeType } from "@/schemas"

export class Shodan extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()

    this.baseURL = "https://www.shodan.io"
    this.name = "Shodan"
    this.type = "ip"
  }

  public href(data: string): string {
    return this.baseURL + `/host/${data}`
  }
}
