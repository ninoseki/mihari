import dayjs from "dayjs";
import dedent from "ts-dedent";
import { v4 } from "uuid";

export function getRuleTemplate(): string {
  const id = v4();
  const now = dayjs();

  return dedent`id: ${id}
                title: Title goes here
                description: Description goes here
                created_on: ${now.format("YYYY-MM-DD")}
                queries: []`;
}
