import { BaseLink } from "@/links/base"
import type { LinkType, LinkTypeType } from "@/schemas"

export class AnyRun extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()
    this.baseURL = "https://app.any.run"
    this.name = "ANY.RUN"
    this.type = "hash"
  }

  public href(data: string): string {
    return this.baseURL + `/submissions/#filehash:${data}`
  }
}
