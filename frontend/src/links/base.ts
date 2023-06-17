export class BaseLink {
  public baseURL: string;

  public constructor() {
    this.baseURL = "https://example.com";
  }

  public favicon(): string {
    return (
      "https://t0.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=" +
      this.baseURL
    );
  }
}
