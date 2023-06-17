import { BaseLink } from "@/links/base";
import { Link, LinkType } from "@/types";

export class DNSlyticsForIP extends BaseLink implements Link {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();

    this.baseURL = "https://dnslytics.com";
    this.name = "DNSlytics";
    this.type = "ip";
  }

  public href(data: string): string {
    return this.baseURL + `/ip/${data}`;
  }
}

export class DNSlyticsForDomain extends BaseLink implements Link {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();

    this.baseURL = "https://dnslytics.com";
    this.name = "DNSlytics";
    this.type = "domain";
  }

  public href(data: string): string {
    return this.baseURL + `/domain/${data}`;
  }
}
