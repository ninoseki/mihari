import { BaseLink } from "@/links/base"
import type { LinkType, LinkTypeType } from "@/schemas"

export class Crtsh extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()

    this.baseURL = "https://crt.sh"
    this.name = "crt.sh"
    this.type = "domain"
  }

  public href(data: string): string {
    return this.baseURL + `/?q=${data}`
  }
}
