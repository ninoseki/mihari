import { BaseLink } from "@/links/base"
import type { LinkType, LinkTypeType } from "@/schemas"

export class Intezer extends BaseLink implements LinkType {
  public baseURL: string
  public name: string
  public type: LinkTypeType

  public constructor() {
    super()

    this.baseURL = "https://analyze.intezer.com"
    this.name = "Intezer"
    this.type = "hash"
  }

  public href(data: string): string {
    return this.baseURL + `/#/files/${data}`
  }
}
