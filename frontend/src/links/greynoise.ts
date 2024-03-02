import { BaseLink } from "@/links/base"
import type { LinkType, LinkTypeType } from "@/schemas"

export class GreyNoise extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()

    this.baseURL = "https://viz.greynoise.io"
    this.name = "GreyNoise"
    this.type = "ip"
  }

  public href(data: string): string {
    return this.baseURL + `/ip/${data}`
  }
}
