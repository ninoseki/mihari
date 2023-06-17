import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
import timezone from "dayjs/plugin/timezone";
import utc from "dayjs/plugin/utc";
import { LocationQueryValue } from "vue-router";

import { getCountryByCode } from "@/countries";
import { GCS, IPInfo } from "@/types";

dayjs.extend(relativeTime);
dayjs.extend(timezone);
dayjs.extend(utc);

export function getLocalDatetime(datetime: string): string {
  return dayjs(datetime).local().format("YYYY-MM-DD HH:mm:ss");
}

export function getHumanizedRelativeTime(datetime: string): string {
  return dayjs(datetime).local().fromNow();
}

export function getGCSByCountryCode(countryCode: string): GCS | undefined {
  const country = getCountryByCode(countryCode);
  if (country !== undefined) {
    return { lat: country.lat, long: country.long };
  }
}

export function getGCSByIPInfo(ipinfo: IPInfo): GCS | undefined {
  if (ipinfo.loc !== undefined) {
    const numbers = ipinfo.loc.split(",");
    if (numbers.length === 2) {
      const lat = numbers[0];
      const long = numbers[1];

      return { lat: parseFloat(lat), long: parseFloat(long) };
    }
  }
  return getGCSByCountryCode(ipinfo.countryCode);
}

export function normalizeQueryParam(
  param:
    | undefined
    | null
    | string
    | string[]
    | LocationQueryValue
    | LocationQueryValue[]
): string | undefined {
  if (param === undefined || param === null) {
    return undefined;
  }

  if (typeof param === "string") {
    return param;
  }

  return param.toString();
}
