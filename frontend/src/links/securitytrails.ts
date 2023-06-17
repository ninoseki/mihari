import { BaseLink } from "@/links/base";
import { Link, LinkType } from "@/types";

class SecurityTrails extends BaseLink {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();

    this.baseURL = "https://securitytrails.com";
    this.name = "SecurityTrails";
    this.type = "domain";
  }
}

export class SecurityTrailsForDomain extends SecurityTrails implements Link {
  public constructor() {
    super();
    this.type = "domain";
  }

  public href(data: string): string {
    return this.baseURL + `/domain/${data}/dns`;
  }
}

export class SecurityTrailsForIP extends SecurityTrails implements Link {
  public constructor() {
    super();
    this.type = "ip";
  }

  public href(data: string): string {
    return this.baseURL + `/list/ip/${data}`;
  }
}
