import { BaseLink } from "@/links/base";
import { Link, LinkType } from "@/types";

export class Censys extends BaseLink implements Link {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();

    this.baseURL = "https://search.censys.io";
    this.name = "Censys";
    this.type = "ip";
  }

  public href(data: string): string {
    return this.baseURL + `/hosts/${data}`;
  }
}
