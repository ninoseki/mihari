import dayjs from "dayjs"
import relativeTime from "dayjs/plugin/relativeTime"
import timezone from "dayjs/plugin/timezone"
import utc from "dayjs/plugin/utc"

import { getCountryByCode } from "@/countries"
import type { GCS, IPInfo } from "@/types"

dayjs.extend(relativeTime)
dayjs.extend(timezone)
dayjs.extend(utc)

export function getLocalDatetime(datetime: string): string {
  return dayjs(datetime).local().format("YYYY-MM-DD HH:mm:ss")
}

export function getHumanizedRelativeTime(datetime: string): string {
  return dayjs(datetime).local().fromNow()
}

export function getGCSByCountryCode(countryCode: string): GCS | undefined {
  const country = getCountryByCode(countryCode)
  if (country !== undefined) {
    return { lat: country.lat, long: country.long }
  }
}

export function getGCSByIPInfo(ipinfo: IPInfo): GCS | undefined {
  if (ipinfo.loc !== undefined) {
    const numbers = ipinfo.loc.split(",")
    if (numbers.length === 2) {
      const lat = numbers[0]
      const long = numbers[1]

      return { lat: parseFloat(lat), long: parseFloat(long) }
    }
  }
  return getGCSByCountryCode(ipinfo.countryCode)
}

export function normalizeQuery(value: string | string[] | null): string | undefined {
  if (value === "" || !value) {
    return undefined
  }
  return value.toString()
}
