import { BaseLink } from "@/links/base"
import type { LinkType, LinkTypeType } from "@/schemas"

export class EmailRep extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()
    this.baseURL = "https://emailrep.io"
    this.name = "EmailRep"
    this.type = "mail"
  }

  public href(data: string): string {
    return this.baseURL + `/${data}`
  }
}
