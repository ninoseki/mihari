import { getHumanizedRelativeTime } from "@/utils";

describe("getHumanizedRelativeTime", () => {
  it("returns a relative time in humanized format", () => {
    expect(getHumanizedRelativeTime("1970-01-01 00:00:00")).toContain("years");
  });
});
