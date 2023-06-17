import { BaseLink } from "@/links/base";
import { Link, LinkType } from "@/types";

export class Crtsh extends BaseLink implements Link {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();

    this.baseURL = "https://crt.sh";
    this.name = "crt.sh";
    this.type = "domain";
  }

  public href(data: string): string {
    return this.baseURL + `/?q=${data}`;
  }
}
