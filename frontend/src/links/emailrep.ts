import { BaseLink } from "@/links/base"
import type { Link, LinkType } from "@/types"

export class EmailRep extends BaseLink implements Link {
  public baseURL: string
  public name: string
  public type: LinkType

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
