import { BaseLink } from "@/links/base";
import { Link, LinkType } from "@/types";

export class AnyRun extends BaseLink implements Link {
  public baseURL: string;
  public name: string;
  public type: LinkType;

  public constructor() {
    super();
    this.baseURL = "https://app.any.run";
    this.name = "ANY.RUN";
    this.type = "hash";
  }

  public href(data: string): string {
    return this.baseURL + `/submissions/#filehash:${data}`;
  }
}
