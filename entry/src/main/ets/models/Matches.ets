import { Competition } from "./Comptetitions"

export interface Matches {
  filters: Filters
  resultSet: ResultSet
  competition: Competition
  matches: Match[]
}

export interface Filters {
  season: string
}

export interface ResultSet {
  count: number
  first: string
  last: string
  played: number
}



export interface Match {
  area: Area
  competition: Competition
  season: Season
  id: number
  utcDate: string
  status: string
  matchday: number
  stage: string
  group?: object
  lastUpdated: string
  homeTeam: Team
  awayTeam: Team
  score: Score
  odds: Odds
  referees?: Referee[]
}

export interface Area {
  id: number
  name: string
  code: string
  flag: string
}

export interface Season {
  id: number
  startDate: string
  endDate: string
  currentMatchday: number
  winner?: object
}

export interface Team {
  id: number
  name: string
  shortName: string
  tla: string
  crest: string
}

export interface Score {
  winner?: string
  duration: string
  fullTime: FullTime
  halfTime: HalfTime
}

export interface FullTime {
  home?: number
  away?: number
}

export interface HalfTime {
  home?: number
  away?: number
}

export interface Odds {
  msg: string
}

export interface Referee {
  id: number
  name: string
  type: string
  nationality: string
}
