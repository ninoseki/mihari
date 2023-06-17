import { BaseLink } from "@/links/base";
import { Link, LinkType } from "@/types";

export class Intezer extends BaseLink implements Link {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();

    this.baseURL = "https://analyze.intezer.com";
    this.name = "Intezer";
    this.type = "hash";
  }

  public href(data: string): string {
    return this.baseURL + `/#/files/${data}`;
  }
}
