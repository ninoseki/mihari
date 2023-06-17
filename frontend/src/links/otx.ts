import { BaseLink } from "@/links/base";
import { Link, LinkType } from "@/types";

export class OtxForIP extends BaseLink implements Link {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();

    this.baseURL = "https://otx.alienvault.com";
    this.name = "OTX";
    this.type = "ip";
  }

  public href(data: string): string {
    return this.baseURL + `/indicator/ip/${data}`;
  }
}

export class OtxForDomain extends OtxForIP implements Link {
  public type: LinkType;

  public constructor() {
    super();
    this.type = "domain";
  }

  public href(data: string): string {
    return this.baseURL + `/indicator/domain/${data}`;
  }
}
