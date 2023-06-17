import { BaseLink } from "@/links/base";
import { Link, LinkType } from "@/types";

export class Shodan extends BaseLink implements Link {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();

    this.baseURL = "https://www.shodan.io";
    this.name = "Shodan";
    this.type = "ip";
  }

  public href(data: string): string {
    return this.baseURL + `/host/${data}`;
  }
}
