import { BaseLink } from "@/links/base"
import type { LinkType, LinkTypeType } from "@/schemas"

export class Censys extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()

    this.baseURL = "https://search.censys.io"
    this.name = "Censys"
    this.type = "ip"
  }

  public href(data: string): string {
    return this.baseURL + `/hosts/${data}`
  }
}
