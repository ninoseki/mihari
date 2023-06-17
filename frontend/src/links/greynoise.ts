import { BaseLink } from "@/links/base";
import { Link, LinkType } from "@/types";

export class GreyNoise extends BaseLink implements Link {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();

    this.baseURL = "https://www.greynoise.io";
    this.name = "GreyNoise";
    this.type = "ip";
  }

  public href(data: string): string {
    return this.baseURL + `/viz/query?gnql=ip:${data}`;
  }
}
